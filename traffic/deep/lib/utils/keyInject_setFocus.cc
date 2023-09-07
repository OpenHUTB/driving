#include <windows.h>
#include "mex.h"

int main(char* windowNameBuf)

{

	HWND hwndNew = FindWindow(NULL,TEXT(windowNameBuf));

	if (hwndNew != 0)

	{
		SetForegroundWindow(hwndNew);
		Sleep(5);
	}

	else
	{
		mexPrintf("Could not find window of that name...\n");
		return 1;
	}
	
	return 0;

}


// The gateway routine
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{

	// Input argument is a buffer to hold the window name
	char *windowNameBuf;
	mwSize buflen1;
	const mxArray *string_array_ptr1 = prhs[0];
	buflen1 = mxGetNumberOfElements(string_array_ptr1) + 1;
	windowNameBuf = (char *) mxCalloc(buflen1, sizeof(char));
	mxGetString(string_array_ptr1, windowNameBuf, buflen1);

	// Call the C subroutine.
	main(windowNameBuf);

}