First Input 

pth=Input the Cdose acquisition directory. 


Second Input 

Specify if you want to sum or average the image stack or just want to leave it alone.
 'Sum'= The image stack is summed across the third dimension.
 'Mean'=The image stack is averaged across the third dimension.
 'None'= Leave the stack as it is. This will take up a lot of memory


Output: 
The function returns a structure with all the image acquistions and important meta information about the image.

PS:Note that this function is only going to check folders in directory you specified. If you have other folders in your directory this function does have a check for that but it's not too robust. Do check your struct if you have any folders you want to remove.



% Ramish Ashraf 10/24/2019


