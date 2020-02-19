pth=Input the Cdose acquisition directory. Please provide the path with just single quotation marks. i.e 'data/custom....' and not "data/custom"
The function returns a structure with all the Image acquistions and important meta information about the image.

Optional Input: Specify if you want to sum or average the image stack orjust want to leave it alone\
% 'Sum'= The image stack is summed across the third dimension.
% 'Mean'=The iamge stack is averaged across the third dimension.
% 'None'= Leave the stack as it is. This will take up a lot of memory
%  Note that this function is only going to check folders in directory you specified. If you have other folders in your directory this function does have a check for that but it's not too robust. Do check your struct if you have any folders you want to remove.



% Ramish Ashraf 10/24/2019
