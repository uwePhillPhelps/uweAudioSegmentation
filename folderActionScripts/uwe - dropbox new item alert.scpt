FasdUAS 1.101.10   ��   ��    k             l      ��  ��    j d
this code is descended from Apple sample code.
The original script was "add - new item alert.scpt"
     � 	 	 � 
 t h i s   c o d e   i s   d e s c e n d e d   f r o m   A p p l e   s a m p l e   c o d e . 
 T h e   o r i g i n a l   s c r i p t   w a s   " a d d   -   n e w   i t e m   a l e r t . s c p t " 
   
  
 l     ��������  ��  ��        l     ��  ��    H B name of config script (in /Library/Scripts/Folder Action Scripts)     �   �   n a m e   o f   c o n f i g   s c r i p t   ( i n   / L i b r a r y / S c r i p t s / F o l d e r   A c t i o n   S c r i p t s )      j     �� �� ,0 configscriptfilename configScriptFilename  m        �   8 u w e   -   c o n f i g   p r o p e r t i e s . s c p t      l     ��������  ��  ��        l     ��  ��    0 * global properties filled by config script     �   T   g l o b a l   p r o p e r t i e s   f i l l e d   b y   c o n f i g   s c r i p t      j    �� �� 0 dialog_timeout    m    ��
�� 
null     !   j    �� "�� 0 php_processing_web_address   " m    ��
�� 
null !  # $ # j   	 �� %�� !0 php_audio_segmentation_folder   % m   	 
��
�� 
null $  & ' & j    �� (�� 0 php_incoming_folder   ( m    ��
�� 
null '  ) * ) j    �� +�� 0 alert_question   + m    ��
�� 
null *  , - , j    �� .�� 0 segmentation_script_name   . m    ��
�� 
null -  / 0 / l     ��������  ��  ��   0  1 2 1 l     3 4 5 3 I     �� 6���� 0 load_config_properties   6  7�� 7 m    ��
�� 
null��  ��   4 ? 9 this line does not run when finder invokes folder action    5 � 8 8 r   t h i s   l i n e   d o e s   n o t   r u n   w h e n   f i n d e r   i n v o k e s   f o l d e r   a c t i o n 2  9 : 9 l      �� ; <��   ; # debug_config_properties(null)    < � = = : d e b u g _ c o n f i g _ p r o p e r t i e s ( n u l l ) :  > ? > l     ��������  ��  ��   ?  @ A @ i     B C B I     �� D E
�� .facofgetnull���     alis D o      ���� 0 this_folder   E �� F��
�� 
flst F o      ���� 0 added_items  ��   C k     � G G  H I H l     ��������  ��  ��   I  J K J l     L M N L I     �� O���� 0 load_config_properties   O  P�� P m    ��
�� 
null��  ��   M ; 5 this line does run when finder invokes folder action    N � Q Q j   t h i s   l i n e   d o e s   r u n   w h e n   f i n d e r   i n v o k e s   f o l d e r   a c t i o n K  R S R I    �� T���� 0 debug_config_properties   T  U�� U m    	��
�� 
null��  ��   S  V W V l   ��������  ��  ��   W  X�� X X    � Y�� Z Y k    � [ [  \ ] \ O    ` ^ _ ^ Q   " _ ` a b ` k   % : c c  d e d l   % %�� f g��   f � �
				set the folder_name to the name of this_folder				show the items in the folder				open this_folder				reveal the added_items
				    g � h h 
 	 	 	 	 s e t   t h e   f o l d e r _ n a m e   t o   t h e   n a m e   o f   t h i s _ f o l d e r  	 	 	 	 s h o w   t h e   i t e m s   i n   t h e   f o l d e r  	 	 	 	 o p e n   t h i s _ f o l d e r  	 	 	 	 r e v e a l   t h e   a d d e d _ i t e m s 
 	 	 	 	 e  i j i l  % %��������  ��  ��   j  k l k l  % %�� m n��   m * $ retrieve just the file name as text    n � o o H   r e t r i e v e   j u s t   t h e   f i l e   n a m e   a s   t e x t l  p q p r   % , r s r l  % * t���� t c   % * u v u n   % ( w x w 1   & (��
�� 
pnam x o   % &���� 0 current_file_alias   v m   ( )��
�� 
ctxt��  ��   s o      ���� 0 current_file_name   q  y z y l  - -��������  ��  ��   z  { | { l  - -�� } ~��   } ' ! move the items to the php folder    ~ �   B   m o v e   t h e   i t e m s   t o   t h e   p h p   f o l d e r |  ��� � I  - :�� � �
�� .coremoveobj        obj  � o   - .���� 0 current_file_alias   � �� ���
�� 
insh � l  / 6 ����� � c   / 6 � � � o   / 4���� 0 php_incoming_folder   � m   4 5��
�� 
alis��  ��  ��  ��   a R      �� ���
�� .ascrerr ****      � **** � o      ���� 
0 errmsg  ��   b k   B _ � �  � � � I  B Y�� ���
�� .sysodlogaskr        TEXT � b   B U � � � b   B O � � � b   B K � � � b   B I � � � b   B E � � � m   B C � � � � � Z T h e   f i n d e r   e n c o u n t e r e d   a n   e r r o r   m o v i n g   f i l e s   � o   C D��
�� 
ret  � m   E H � � � � � � I t   i s   r e c o m m e n d e d   t h a t   y o u   m a n u a l l y   c h e c k   w h i c h   f i l e s   r e m a i n   i n   � o   I J���� 0 this_folder   � m   K N � � � � � X   a n d   w h i c h   f i l e s   w e r e   s u c c e s s f u l l y   m o v e d   t o   � o   O T���� 0 php_incoming_folder  ��   �  ��� � I  Z _�� ���
�� .sysodlogaskr        TEXT � o   Z [���� 
0 errmsg  ��  ��   _ m     � ��                                                                                  MACS  alis    h  	MacOS10p6                  Ȑ!H+     �
Finder.app                                                       �:��o        ����  	                CoreServices    Ȑ       ���_       �   ?   >  0MacOS10p6:System:Library:CoreServices:Finder.app   
 F i n d e r . a p p   	 M a c O S 1 0 p 6  &System/Library/CoreServices/Finder.app  / ��   ]  � � � l  a a��������  ��  ��   �  � � � Q   a � � � � � k   d � � �  � � � l  d d��������  ��  ��   �  � � � I  d k�� ���
�� .sysodlogaskr        TEXT � m   d g � � � � � B r u n n i n g   a u d i o   s e g m e n t a t i o n   s c r i p t��   �  � � � l  l l��������  ��  ��   �  � � � l  l l�� � ���   � 5 / prepare POSIX paths to php audio segmentation     � � � � ^   p r e p a r e   P O S I X   p a t h s   t o   p h p   a u d i o   s e g m e n t a t i o n   �  � � � r   l y � � � n   l w � � � 1   s w��
�� 
psxp � l  l s ����� � c   l s � � � o   l q���� 0 php_incoming_folder   � m   q r��
�� 
alis��  ��   � o      ���� 20 php_incoming_posix_path php_incoming_POSIX_path �  � � � r   z � � � � n   z � � � � 1   � ���
�� 
psxp � l  z � ����� � c   z � � � � o   z ���� !0 php_audio_segmentation_folder   � m    ���
�� 
alis��  ��   � o      ���� F0 !php_audio_segmentation_posix_path !php_audio_segmentation_POSIX_path �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � 4 . prepare argument for segmentation bash script    � � � � \   p r e p a r e   a r g u m e n t   f o r   s e g m e n t a t i o n   b a s h   s c r i p t �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ����� 20 php_incoming_posix_path php_incoming_POSIX_path � m   � � � � � � �  / � o   � ����� 0 current_file_name   � o      ���� !0 segmentation_script_arguments   �  � � � l  � ���������  ��  ��   �  � � � r   � � � � � b   � � � � � b   � � � � � m   � � � � � � �  c d   � o   � ����� F0 !php_audio_segmentation_posix_path !php_audio_segmentation_POSIX_path � m   � � � � � � �  ;   � o      ���� 0 command_to_run   �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � ����� 0 command_to_run   � m   � � � � � � �  . / � o   � ��� 0 segmentation_script_name   � m   � � � � � � �    � o   � ��~�~ !0 segmentation_script_arguments   � o      �}�} 0 command_to_run   �  � � � l  � ��|�{�z�|  �{  �z   �  � � � I  � ��y ��x
�y .sysodlogaskr        TEXT � o   � ��w�w 0 command_to_run  �x   �  ��v � Q   � � � � � � O   � � �  � k   � �  I  � ��u�t
�u .coredoscnull��� ��� ctxt o   � ��s�s 0 command_to_run  �t   �r I  � ��q�p
�q .coredoscnull��� ��� ctxt m   � � �  e x i t�p  �r    m   � �		�                                                                                      @ alis    b  	MacOS10p6                  Ȑ!H+     �Terminal.app                                                     Y��<��        ����  	                	Utilities     Ȑ       �<��       �   �  -MacOS10p6:Applications:Utilities:Terminal.app     T e r m i n a l . a p p   	 M a c O S 1 0 p 6  #Applications/Utilities/Terminal.app   / ��   � R      �o
�n
�o .ascrerr ****      � ****
 o      �m�m 
0 errmsg  �n   � I  � ��l�k
�l .sysodlogaskr        TEXT o   � ��j�j 
0 errmsg  �k  �v   � R      �i�h
�i .ascrerr ****      � **** o      �g�g 
0 errmsg  �h   � I  � ��f�e
�f .sysodlogaskr        TEXT o   � ��d�d 
0 errmsg  �e   �  l  � ��c�b�a�c  �b  �a   �` l  � ��_�^�]�_  �^  �]  �`  �� 0 current_file_alias   Z o    �\�\ 0 added_items  ��   A  l     �[�Z�Y�[  �Z  �Y    i     I      �X�W�X 0 load_config_properties   �V m      �U
�U 
null�V  �W   k     �  l     �T�T   J D--------------------------------------------------------------------    � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   l     �S!"�S  ! ) # load from config properties script   " �## F   l o a d   f r o m   c o n f i g   p r o p e r t i e s   s c r i p t  $%$ l     �R&'�R  & J D--------------------------------------------------------------------   ' �(( � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -% )*) l     �Q�P�O�Q  �P  �O  * +,+ Q     @-./- r    010 c    
232 o    �N�N ,0 configscriptfilename configScriptFilename3 m    	�M
�M 
alis1 o      �L�L &0 configscriptalias configScriptAlias. R      �K�J�I
�K .ascrerr ****      � ****�J  �I  / Q    @45�H4 k    766 787 O   %9:9 r    $;<; n    "=>= m     "�G
�G 
cfol> l    ?�F�E? I    �D@�C
�D .earsffdralis        afdr@  f    �C  �F  �E  < o      �B�B 0 
thisfolder 
thisFolder: m    AA�                                                                                  MACS  alis    h  	MacOS10p6                  Ȑ!H+     �
Finder.app                                                       �:��o        ����  	                CoreServices    Ȑ       ���_       �   ?   >  0MacOS10p6:System:Library:CoreServices:Finder.app   
 F i n d e r . a p p   	 M a c O S 1 0 p 6  &System/Library/CoreServices/Finder.app  / ��  8 BCB r   & 1DED b   & /FGF l  & )H�A�@H c   & )IJI o   & '�?�? 0 
thisfolder 
thisFolderJ m   ' (�>
�> 
TEXT�A  �@  G o   ) .�=�= ,0 configscriptfilename configScriptFilenameE o      �<�< &0 configscriptalias configScriptAliasC K�;K r   2 7LML c   2 5NON o   2 3�:�: &0 configscriptalias configScriptAliasO m   3 4�9
�9 
alisM o      �8�8 &0 configscriptalias configScriptAlias�;  5 R      �7�6�5
�7 .ascrerr ****      � ****�6  �5  �H  , PQP l  A A�4�3�2�4  �3  �2  Q RSR r   A HTUT I  A F�1V�0
�1 .sysoloadscpt        fileV o   A B�/�/ &0 configscriptalias configScriptAlias�0  U o      �.�. 0 configscript configScriptS WXW l  I I�-�,�+�-  �,  �+  X YZY l  I I�*[\�*  [ 9 3 set the amount of time before dialogs auto-answer.   \ �]] f   s e t   t h e   a m o u n t   o f   t i m e   b e f o r e   d i a l o g s   a u t o - a n s w e r .Z ^_^ r   I R`a` n   I Lbcb o   J L�)�) 0 dialog_timeout  c o   I J�(�( 0 configscript configScripta o      �'�' 0 dialog_timeout  _ ded l  S S�&�%�$�&  �%  �$  e fgf l  S S�#hi�#  h    for php processing script   i �jj 4   f o r   p h p   p r o c e s s i n g   s c r i p tg klk r   S \mnm n   S Vopo o   T V�"�" 0 php_processing_web_address  p o   S T�!�! 0 configscript configScriptn o      � �  0 php_processing_web_address  l qrq l  ] ]����  �  �  r sts r   ] fuvu n   ] `wxw o   ^ `�� !0 php_audio_segmentation_folder  x o   ] ^�� 0 configscript configScriptv o      �� !0 php_audio_segmentation_folder  t yzy r   g p{|{ n   g j}~} o   h j�� 0 php_incoming_folder  ~ o   g h�� 0 configscript configScript| o      �� 0 php_incoming_folder  z � l  q q����  �  �  � ��� r   q z��� n   q t��� o   r t�� 0 segmentation_script_name  � o   q r�� 0 configscript configScript� o      �� 0 segmentation_script_name  � ��� l  { {����  �  �  � ��� l  { {����  �   question to ask user   � ��� *   q u e s t i o n   t o   a s k   u s e r� ��� r   { ���� n   { ~��� o   | ~�� 0 alert_question  � o   { |�
�
 0 configscript configScript� o      �	�	 0 alert_question  �   ��� l     ����  �  �  � ��� i     ��� I      ���� 0 debug_config_properties  � ��� m      �
� 
null�  �  � k     G�� ��� l     � �����   ��  ��  � ��� r     ��� b     	��� b     ��� m     �� ��� 
 p a s f :� o    ���� !0 php_audio_segmentation_folder  � o    ��
�� 
ret � o      ���� 0 msg  � ��� r    ��� b    ��� b    ��� b    ��� o    ���� 0 msg  � m    �� ��� 
 p i f :  � o    ���� 0 php_incoming_folder  � o    ��
�� 
ret � o      ���� 0 msg  � ��� r    '��� b    %��� b    #��� b    ��� o    ���� 0 msg  � m    �� ���  p p w a :  � o    "���� 0 php_processing_web_address  � o   # $��
�� 
ret � o      ���� 0 msg  � ��� r   ( 5��� b   ( 3��� b   ( 1��� b   ( +��� o   ( )���� 0 msg  � m   ) *�� ���  a q :  � o   + 0���� 0 alert_question  � o   1 2��
�� 
ret � o      ���� 0 msg  � ��� r   6 A��� b   6 ?��� b   6 9��� o   6 7���� 0 msg  � m   7 8�� ��� 
 s s n :  � o   9 >���� 0 segmentation_script_name  � o      ���� 0 msg  � ��� l  B B��������  ��  ��  � ���� I  B G�����
�� .sysodlogaskr        TEXT� o   B C���� 0 msg  ��  ��  �       ��� ������������������  � ������������������������ ,0 configscriptfilename configScriptFilename�� 0 dialog_timeout  �� 0 php_processing_web_address  �� !0 php_audio_segmentation_folder  �� 0 php_incoming_folder  �� 0 alert_question  �� 0 segmentation_script_name  
�� .facofgetnull���     alis�� 0 load_config_properties  �� 0 debug_config_properties  
�� .aevtoappnull  �   � ****
�� 
null
�� 
null
�� 
null
�� 
null
�� 
null
�� 
null� �� C��������
�� .facofgetnull���     alis�� 0 this_folder  �� ������
�� 
flst�� 0 added_items  ��  � 	�������������������� 0 this_folder  �� 0 added_items  �� 0 current_file_alias  �� 0 current_file_name  �� 
0 errmsg  �� 20 php_incoming_posix_path php_incoming_POSIX_path�� F0 !php_audio_segmentation_posix_path !php_audio_segmentation_POSIX_path�� !0 segmentation_script_arguments  �� 0 command_to_run  � ������������ ��������������� ��� � ��� ��� � � � � �	��
�� 
null�� 0 load_config_properties  �� 0 debug_config_properties  
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
pnam
�� 
ctxt
�� 
insh
�� 
alis
�� .coremoveobj        obj �� 
0 errmsg  ��  
�� 
ret 
�� .sysodlogaskr        TEXT
�� 
psxp
�� .coredoscnull��� ��� ctxt�� �*�k+ O*�k+ O �[��l kh � ? ��,�&E�O��b  �&l W $X  ��%a %�%a %b  %j O�j UO }a j Ob  �&a ,E�Ob  �&a ,E�O�a %�%E�Oa �%a %E�O�a %b  %a %�%E�O�j O a  �j Oa j UW X  �j W X  �j OP[OY�-� ������������ 0 load_config_properties  �� ����� �  ��
�� 
null��  � �������� &0 configscriptalias configScriptAlias�� 0 
thisfolder 
thisFolder�� 0 configscript configScript� ������A��������������������
�� 
alis��  ��  
�� .earsffdralis        afdr
�� 
cfol
�� 
TEXT
�� .sysoloadscpt        file�� 0 dialog_timeout  �� 0 php_processing_web_address  �� !0 php_audio_segmentation_folder  �� 0 php_incoming_folder  �� 0 segmentation_script_name  �� 0 alert_question  �� � b   �&E�W 3X   %� )j �,E�UO��&b   %E�O��&E�W X  hO�j E�O��,Ec  O��,Ec  O��,Ec  O��,Ec  O��,Ec  O��,Ec  � ������������� 0 debug_config_properties  �� ����� �  ��
�� 
null��  � ���� 0 msg  � ���������
�� 
ret 
�� .sysodlogaskr        TEXT�� H�b  %�%E�O��%b  %�%E�O��%b  %�%E�O��%b  %�%E�O��%b  %E�O�j � �����������
�� .aevtoappnull  �   � ****� k     ��  1����  ��  ��  �  � ����
�� 
null�� 0 load_config_properties  �� *�k+ ascr  ��ޭ