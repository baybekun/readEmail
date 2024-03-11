//using System;
//using System.Timers;

//class Program
//{
//    private static DateTime startTime;
//    private static System.Timers.Timer timer;

//    static void Main()
//    {
//        // Record the start time
//        startTime = DateTime.Now;

//        // Create a Timer object with a specified interval (in milliseconds)
//        timer = new System.Timers.Timer(1000); // 1000 milliseconds = 1 second

//        // Hook up the Elapsed event for the timer
//        timer.Elapsed += OnTimerElapsed;

//        // Start the timer
//        timer.Start();

//        Console.WriteLine("Program started.");

//        // Your program logic goes here

//        Console.WriteLine("Press Enter to exit.");
//        Console.ReadLine();

//        // Stop the timer when the program is about to exit
//        timer.Stop();
//    }

//    // Event handler for the Elapsed event
//    private static void OnTimerElapsed(object sender, ElapsedEventArgs e)
//    {
//        // Calculate the elapsed time
//        TimeSpan elapsedTime = DateTime.Now - startTime;

//        // Display the elapsed time
//        Console.WriteLine($"Program has been running for: {elapsedTime}");

//        // Optionally, you can perform other tasks based on elapsed time
//        // For example, stop the program after a certain duration
//        if (elapsedTime.TotalSeconds >= 60)
//        {
//            Console.WriteLine("Program has been running for 1 minute. Stopping...");
//            timer.Stop();
//        }
//    }
//}