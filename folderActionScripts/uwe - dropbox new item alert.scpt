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
null��  ��   4 ? 9 this line does not run when finder invokes folder action    5 � 8 8 r   t h i s   l i n e   d o e s   n o t   r u n   w h e n   f i n d e r   i n v o k e s   f o l d e r   a c t i o n 2  9 : 9 l    ;���� ; I    �� <���� 0 debug_config_properties   <  =�� = m    	��
�� 
null��  ��  ��  ��   :  > ? > l     ��������  ��  ��   ?  @ A @ i     B C B I     �� D E
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
alis��  ��   � o      ���� F0 !php_audio_segmentation_posix_path !php_audio_segmentation_POSIX_path �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � 4 . prepare argument for segmentation bash script    � � � � \   p r e p a r e   a r g u m e n t   f o r   s e g m e n t a t i o n   b a s h   s c r i p t �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ����� 20 php_incoming_posix_path php_incoming_POSIX_path � m   � � � � � � �  / � o   � ����� 0 current_file_name   � o      ���� !0 segmentation_script_arguments   �  � � � l  � �����~��  �  �~   �  � � � r   � � � � � b   � � � � � b   � � � � � m   � � � � � � �  c d   � o   � ��}�} F0 !php_audio_segmentation_posix_path !php_audio_segmentation_POSIX_path � m   � � � � � � �  ;   � o      �|�| 0 command_to_run   �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � ��{�{ 0 command_to_run   � m   � � � � � � �  / b i n / s h   � o   � ��z�z 0 segmentation_script_name   � m   � � � � � � �    � o   � ��y�y !0 segmentation_script_arguments   � o      �x�x 0 command_to_run   �  � � � l  � ��w�v�u�w  �v  �u   �  � � � I  � ��t ��s
�t .sysodlogaskr        TEXT � o   � ��r�r 0 command_to_run  �s   �  ��q � Q   � � � � � � O   � � �  � I  � ��p�o
�p .coredoscnull��� ��� ctxt o   � ��n�n 0 command_to_run  �o    m   � ��                                                                                      @ alis    b  	MacOS10p6                  Ȑ!H+     �Terminal.app                                                     Y��<��        ����  	                	Utilities     Ȑ       �<��       �   �  -MacOS10p6:Applications:Utilities:Terminal.app     T e r m i n a l . a p p   	 M a c O S 1 0 p 6  #Applications/Utilities/Terminal.app   / ��   � R      �m�l
�m .ascrerr ****      � **** o      �k�k 
0 errmsg  �l   � I  � ��j�i
�j .sysodlogaskr        TEXT o   � ��h�h 
0 errmsg  �i  �q   � R      �g�f
�g .ascrerr ****      � **** o      �e�e 
0 errmsg  �f   � I  � ��d�c
�d .sysodlogaskr        TEXT o   � ��b�b 
0 errmsg  �c   �  l  � ��a�`�_�a  �`  �_   	�^	 l  � ��]�\�[�]  �\  �[  �^  �� 0 current_file_alias   Z o    �Z�Z 0 added_items  ��   A 

 l     �Y�X�W�Y  �X  �W    i     I      �V�U�V 0 load_config_properties   �T m      �S
�S 
null�T  �U   k     �  l     �R�R   J D--------------------------------------------------------------------    � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  l     �Q�Q   ) # load from config properties script    � F   l o a d   f r o m   c o n f i g   p r o p e r t i e s   s c r i p t  l     �P �P   J D--------------------------------------------------------------------     �!! � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "#" l     �O�N�M�O  �N  �M  # $%$ Q     @&'(& r    )*) c    
+,+ o    �L�L ,0 configscriptfilename configScriptFilename, m    	�K
�K 
alis* o      �J�J &0 configscriptalias configScriptAlias' R      �I�H�G
�I .ascrerr ****      � ****�H  �G  ( Q    @-.�F- k    7// 010 O   %232 r    $454 n    "676 m     "�E
�E 
cfol7 l    8�D�C8 I    �B9�A
�B .earsffdralis        afdr9  f    �A  �D  �C  5 o      �@�@ 0 
thisfolder 
thisFolder3 m    ::�                                                                                  MACS  alis    h  	MacOS10p6                  Ȑ!H+     �
Finder.app                                                       �:��o        ����  	                CoreServices    Ȑ       ���_       �   ?   >  0MacOS10p6:System:Library:CoreServices:Finder.app   
 F i n d e r . a p p   	 M a c O S 1 0 p 6  &System/Library/CoreServices/Finder.app  / ��  1 ;<; r   & 1=>= b   & /?@? l  & )A�?�>A c   & )BCB o   & '�=�= 0 
thisfolder 
thisFolderC m   ' (�<
�< 
TEXT�?  �>  @ o   ) .�;�; ,0 configscriptfilename configScriptFilename> o      �:�: &0 configscriptalias configScriptAlias< D�9D r   2 7EFE c   2 5GHG o   2 3�8�8 &0 configscriptalias configScriptAliasH m   3 4�7
�7 
alisF o      �6�6 &0 configscriptalias configScriptAlias�9  . R      �5�4�3
�5 .ascrerr ****      � ****�4  �3  �F  % IJI l  A A�2�1�0�2  �1  �0  J KLK r   A HMNM I  A F�/O�.
�/ .sysoloadscpt        fileO o   A B�-�- &0 configscriptalias configScriptAlias�.  N o      �,�, 0 configscript configScriptL PQP l  I I�+�*�)�+  �*  �)  Q RSR l  I I�(TU�(  T 9 3 set the amount of time before dialogs auto-answer.   U �VV f   s e t   t h e   a m o u n t   o f   t i m e   b e f o r e   d i a l o g s   a u t o - a n s w e r .S WXW r   I RYZY n   I L[\[ o   J L�'�' 0 dialog_timeout  \ o   I J�&�& 0 configscript configScriptZ o      �%�% 0 dialog_timeout  X ]^] l  S S�$�#�"�$  �#  �"  ^ _`_ l  S S�!ab�!  a    for php processing script   b �cc 4   f o r   p h p   p r o c e s s i n g   s c r i p t` ded r   S \fgf n   S Vhih o   T V� �  0 php_processing_web_address  i o   S T�� 0 configscript configScriptg o      �� 0 php_processing_web_address  e jkj l  ] ]����  �  �  k lml r   ] fnon n   ] `pqp o   ^ `�� !0 php_audio_segmentation_folder  q o   ] ^�� 0 configscript configScripto o      �� !0 php_audio_segmentation_folder  m rsr r   g ptut n   g jvwv o   h j�� 0 php_incoming_folder  w o   g h�� 0 configscript configScriptu o      �� 0 php_incoming_folder  s xyx l  q q����  �  �  y z{z r   q z|}| n   q t~~ o   r t�� 0 segmentation_script_name   o   q r�� 0 configscript configScript} o      �� 0 segmentation_script_name  { ��� l  { {����  �  �  � ��� l  { {����  �   question to ask user   � ��� *   q u e s t i o n   t o   a s k   u s e r� ��
� r   { ���� n   { ~��� o   | ~�	�	 0 alert_question  � o   { |�� 0 configscript configScript� o      �� 0 alert_question  �
   ��� l     ����  �  �  � ��� i     ��� I      ���� 0 debug_config_properties  � �� � m      ��
�� 
null�   �  � k     G�� ��� l     ��������  ��  ��  � ��� r     ��� b     	��� b     ��� m     �� ��� 
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
�� .sysodlogaskr        TEXT� o   B C���� 0 msg  ��  ��  �       ��� �������������  � ������������������������ ,0 configscriptfilename configScriptFilename�� 0 dialog_timeout  �� 0 php_processing_web_address  �� !0 php_audio_segmentation_folder  �� 0 php_incoming_folder  �� 0 alert_question  �� 0 segmentation_script_name  
�� .facofgetnull���     alis�� 0 load_config_properties  �� 0 debug_config_properties  
�� .aevtoappnull  �   � ****�� � ��� 8 h t t p : / / 1 2 7 . 0 . 0 . 1 / p r o c e s s i n g /� ��� � L o c a l H D : d e v - s n a p s h o t s : u w e A u d i o S e g m e n t a t i o n : p h p T o o l s - s r c : a u d i o S e g m e n t a t i o n� ��� � L o c a l H D : d e v - s n a p s h o t s : u w e A u d i o S e g m e n t a t i o n : p h p T o o l s - s r c : a u d i o S e g m e n t a t i o n : i n c o m i n g� ��� � D o   y o u   w a n t   t o   o p e n   a   w e b - b r o w s e r   t o   u s e   t h e   P H P   p r o c e s s i n g   i n t e r f a c e ?� ���  _ t e s t S c r i p t . s h� �� C��������
�� .facofgetnull���     alis�� 0 this_folder  �� ������
�� 
flst�� 0 added_items  ��  � 	�������������������� 0 this_folder  �� 0 added_items  �� 0 current_file_alias  �� 0 current_file_name  �� 
0 errmsg  �� 20 php_incoming_posix_path php_incoming_POSIX_path�� F0 !php_audio_segmentation_posix_path !php_audio_segmentation_POSIX_path�� !0 segmentation_script_arguments  �� 0 command_to_run  � ������������ ��������������� ��� � ��� ��� � � � � ���
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
�� .coredoscnull��� ��� ctxt�� �*�k+ O*�k+ O ١[��l kh � ? ��,�&E�O��b  �&l W $X  ��%a %�%a %b  %j O�j UO ua j Ob  �&a ,E�Ob  �&a ,E�O�a %�%E�Oa �%a %E�O�a %b  %a %�%E�O�j O a  �j UW X  �j W X  �j OP[OY�5� ������������ 0 load_config_properties  �� ����� �  ��
�� 
null��  � �������� &0 configscriptalias configScriptAlias�� 0 
thisfolder 
thisFolder�� 0 configscript configScript� ������:��������������������
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
�� .aevtoappnull  �   � ****� k     ��  1��  9����  ��  ��  �  � ������
�� 
null�� 0 load_config_properties  �� 0 debug_config_properties  �� *�k+ O*�k+ ascr  ��ޭ