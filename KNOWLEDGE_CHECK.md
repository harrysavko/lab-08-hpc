# Lab 08: Knowledge check

**Answer each question below it, in your own words, in one to three sentences.** Replace the `...` below **Your answer:** with your text. Questions 1 and 3 also ask for saved output, which goes into the directory `results/`.

## 1. Slurm: what jobs have I submitted?

**Your task:** print a history of all your Slurm job submissions *since November 4, 2026*. Format the output to include the job ID, job name, node list, partition, account, user, state, start time, and elapsed time. See the job accounting fields in the [sacct documentation](https://slurm.schedmd.com/sacct.html). You may also ask Claude Code or another LLM for the exact command. 

Redirect the command's output to `results/job-history.txt` and include the file in your submission. Do not worry if some earlier jobs failed or were canceled. The complete history should show your process, including trial and error.

*Hint:* See [Part 1, Step 6](README.md#step-6-check-how-the-tasks-ended) in the README.

**Your answer:** Provide the entire command you used, including all CLI options.
sacct -X -S 2026-11-04 --format=JobID,JobName,NodeList,Partition,Account,User,State,Start,Elapsed > results/job-history.txt


## 2. Slurm: did every array task run at the same time?

You submitted your entire job array with one `sbatch` command, but Slurm scheduled each task separately.

**Your task:** in the job history from Question 1, find the tasks from your most recent completed array run. Compare their start times and elapsed times.

*Hint:* See [Part 1, Step 5](README.md#step-5-watch-the-job-array) in the README.

**Your answer:** Did all tasks in the array start at the same time? Was the elapsed time identical for every task? Explain why or why not.

No. The array tasks did not all start at the same time — in job-history.txt their start times run from about 22:19 to 22:50, in groups rather than all at once. That’s because submitting with one sbatch doesn’t make them run simultaneously: Slurm schedules each task separately and only runs as many at a time as the gpu-mig partition has free slots, so the rest wait in the queue until resources free up. The elapsed times were close (~14–19 seconds) but not identical, because each book differs slightly and node load varies.

## 3. Slurm: did my job use what it asked for?

Suppose your next job array has 1,000 books instead of 101. Before you submit it, you want to know whether your script asks for too much or too little memory and time.

**Your task:** run `seff` for **one** task of your finished job array, and save its output as `results/seff.txt`.

*Hint:* `seff` takes the ID of one task, such as `4211873_1`. Compare its **Memory Utilized** and **Job Wall-clock time** with `--mem` and `--time` in your `summarize.slurm`.

**Your answer:** How much memory and time did the task use, compared with what your script asked for? What would you change in your script, and why?

The task used 2.83 GB of the 16 GB requested (about 18%) and finished in 15 seconds out of the 5-minute (00:05:00) limit — so the script over-requests both memory and time. I’d lower --mem to around 4G and --time to around 00:02:00, keeping a safety margin above what was actually used. Because each array task processes a single book, the per-task memory and time won’t grow when the array goes from 101 to 1,000 books — so right-sizing the request lets Slurm pack more tasks onto the hardware at once instead of reserving resources that sit idle.
