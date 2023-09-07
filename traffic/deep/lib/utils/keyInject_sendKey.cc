#include <windows.h>
#include "mex.h"

int main(char* windowNameBuf,int keyStroke,int pressRelease)

{

	HWND desiredHandle = FindWindow(NULL,TEXT(windowNameBuf));

	if (desiredHandle != 0)

	{

		HWND foregroundWindow = GetForegroundWindow();

		if (foregroundWindow == desiredHandle) // only send the key if the desired window is still the foreground window (could get very bad results sending the wrong key combo to a different application)

			{
		
			INPUT ip;
			ip.type = INPUT_KEYBOARD;
			ip.ki.wScan = 0;
			ip.ki.time = 0;
			ip.ki.dwExtraInfo = 0;
	
			// Define key
			ip.ki.wVk = keyStroke;
			
			if (pressRelease == 0)
			{
				// Mimic a press of that key, then a release
				ip.ki.dwFlags = 0;
				SendInput(1, &ip, sizeof(INPUT));

				ip.ki.dwFlags = KEYEVENTF_KEYUP;
				SendInput(1, &ip, sizeof(INPUT));
			}
			else if (pressRelease == 1) 
			{
				// Just a press
				ip.ki.dwFlags = 0;
				SendInput(1, &ip, sizeof(INPUT));
			}
			else if (pressRelease == -1)
			{
				// Just a release				
				ip.ki.dwFlags = KEYEVENTF_KEYUP;
				SendInput(1, &ip, sizeof(INPUT));
			}

			// Give the window time to scratch itself (otherwise you can miss keys)
			Sleep(5);

			}

		else

			mexPrintf("Desired window needs priority - stop clicking so much!\n");

	}

	else

		mexPrintf("Window does not exist!\n");
	
	return 0;

}


// The gateway routine
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{

	// First argument is buffer to hold window name
	char *windowNameBuf;
	mwSize buflen1;
	const mxArray *string_array_ptr1 = prhs[0];
	buflen1 = mxGetNumberOfElements(string_array_ptr1) + 1;
	windowNameBuf = (char *) mxCalloc(buflen1, sizeof(char));
	mxGetString(string_array_ptr1, windowNameBuf, buflen1);

	// Second argument is the key stroke to send, in decimal notation
	double *keyStroke = mxGetPr(prhs[1]);

	// Third argument tells us whether we want to just press (1), just release (-1), or press and release (0)
	double *pressRelease = mxGetPr(prhs[2]);

	// Call the C subroutine.
	main(windowNameBuf,(int) keyStroke[0],(int) pressRelease[0]);

}