
function im_SR = LcRSR(im_l,YH,YL,upscale,patch_size,overlap,tau,preK,K)

[imrow imcol nTraining] = size(YH);

Img_SUM      = zeros(imrow,imcol);
overlap_FLAG = zeros(imrow,imcol);

U = ceil((imrow-overlap)/(patch_size-overlap));  
V = ceil((imcol-overlap)/(patch_size-overlap)); 

% hallucinate the HR image patch by patch
for i = 1:U
    fprintf('.');
   for j = 1:V     

        BlockSize = GetCurrentBlockSize(imrow,imcol,patch_size,overlap,i,j);    
        BlockSizeS = GetCurrentBlockSize(imrow/upscale,imcol/upscale,patch_size/upscale,overlap/upscale,i,j);  
        
        im_l_patch = im_l(BlockSizeS(1):BlockSizeS(2),BlockSizeS(3):BlockSizeS(4));           % extract the patch at position£¨i,j£©of the input LR face     
        im_l_patch = double(reshape(im_l_patch,patch_size*patch_size/(upscale*upscale),1));   % Reshape 2D image patch into 1D column vectors   
        
        XF = Reshape3D(YH,BlockSize);    % reshape each patch of HR face image to one column
        X  = Reshape3D(YL,BlockSizeS);   % reshape each patch of LR face image to one column
        
        distance = dist2(im_l_patch',X');
        [sorted,index] = sort(distance');


        n_index = index(1:preK);
        X = X(:,n_index);
        XF = XF(:,n_index);        
        
        
        [M M2] = dis_matrix_point_linear_SYN(X,XF,im_l_patch);
%         K = 25;
        [mm nn] = sort(M(3,:));
        DL = M(4:size(M),nn(1:K));
        w = solve_weights(DL,im_l_patch,K,tau);
%         factor_L = pinv(DL'*DL)*DL'*im_l_patch;              
        DH = M2(:,nn(1:K));
        Img = DH*w;      

        
        % integrate all the LR patch        
        Img = reshape(Img,patch_size,patch_size);
        Img_SUM(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))      = Img_SUM(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))+Img;
        overlap_FLAG(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4)) = overlap_FLAG(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))+1;
    end
end
%  averaging pixel values in the overlapping regions
im_SR = Img_SUM./overlap_FLAG;
