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
flst F o      ���� 0 added_items  ��   C k     G G  H I H l     ��������  ��  ��   I  J K J l     L M N L I     �� O���� 0 load_config_properties   O  P�� P m    ��
�� 
null��  ��   M ; 5 this line does run when finder invokes folder action    N � Q Q j   t h i s   l i n e   d o e s   r u n   w h e n   f i n d e r   i n v o k e s   f o l d e r   a c t i o n K  R S R l    �� T U��   T # debug_config_properties(null)    U � V V : d e b u g _ c o n f i g _ p r o p e r t i e s ( n u l l ) S  W X W l   ��������  ��  ��   X  Y�� Y X    Z�� [ Z k    \ \  ] ^ ] O    m _ ` _ Q    l a b c a k    3 d d  e f e l    �� g h��   g � �
				set the folder_name to the name of this_folder				show the items in the folder				open this_folder				reveal the added_items
				    h � i i 
 	 	 	 	 s e t   t h e   f o l d e r _ n a m e   t o   t h e   n a m e   o f   t h i s _ f o l d e r  	 	 	 	 s h o w   t h e   i t e m s   i n   t h e   f o l d e r  	 	 	 	 o p e n   t h i s _ f o l d e r  	 	 	 	 r e v e a l   t h e   a d d e d _ i t e m s 
 	 	 	 	 f  j k j l   ��������  ��  ��   k  l m l l   �� n o��   n * $ retrieve just the file name as text    o � p p H   r e t r i e v e   j u s t   t h e   f i l e   n a m e   a s   t e x t m  q r q r    % s t s l   # u���� u c    # v w v n    ! x y x 1    !��
�� 
pnam y o    ���� 0 current_file_alias   w m   ! "��
�� 
ctxt��  ��   t o      ���� 0 current_file_name   r  z { z l  & &��������  ��  ��   {  | } | l  & &�� ~ ��   ~ ' ! move the items to the php folder     � � � B   m o v e   t h e   i t e m s   t o   t h e   p h p   f o l d e r }  ��� � I  & 3�� � �
�� .coremoveobj        obj  � o   & '���� 0 current_file_alias   � �� ���
�� 
insh � l  ( / ����� � c   ( / � � � o   ( -���� 0 php_incoming_folder   � m   - .��
�� 
alis��  ��  ��  ��   b R      �� ���
�� .ascrerr ****      � **** � o      ���� 
0 errmsg  ��   c k   ; l � �  � � � r   ; J � � � b   ; H � � � b   ; B � � � b   ; @ � � � b   ; > � � � m   ; < � � � � � Z T h e   f i n d e r   e n c o u n t e r e d   a n   e r r o r   m o v i n g   f i l e s   � m   < = � � � � � � I t   i s   r e c o m m e n d e d   t h a t   y o u   m a n u a l l y   c h e c k   w h i c h   f i l e s   r e m a i n   i n   � o   > ?���� 0 this_folder   � m   @ A � � � � � X   a n d   w h i c h   f i l e s   w e r e   s u c c e s s f u l l y   m o v e d   t o   � o   B G���� 0 php_incoming_folder   � o      ���� 0 logmsg logMsg �  � � � I  K P�� ���
�� .ascrcmnt****      � **** � o   K L���� 0 logmsg logMsg��   �  � � � I  Q ^�� � �
�� .sysodlogaskr        TEXT � o   Q R���� 0 logmsg logMsg � �� ���
�� 
givu � o   U Z���� 0 dialog_timeout  ��   �  � � � l  _ _��������  ��  ��   �  � � � r   _ f � � � b   _ d � � � m   _ b � � � � � 6 T h e   f u l l   e r r o r   m e s s a g e   w a s   � o   b c���� 
0 errmsg   � o      ���� 0 logmsg logMsg �  ��� � I  g l�� ���
�� .ascrcmnt****      � **** � o   g h���� 0 logmsg logMsg��  ��   ` m     � ��                                                                                  MACS  alis    h  	MacOS10p6                  Ȑ!H+     �
Finder.app                                                       �:��o        ����  	                CoreServices    Ȑ       ���_       �   ?   >  0MacOS10p6:System:Library:CoreServices:Finder.app   
 F i n d e r . a p p   	 M a c O S 1 0 p 6  &System/Library/CoreServices/Finder.app  / ��   ^  � � � l  n n��������  ��  ��   �  � � � Q   n � � � � k   q � � �  � � � r   q v � � � m   q t � � � � � T p r e p a r i n g   t o   r u n   a u d i o   s e g m e n t a t i o n   s c r i p t � o      ���� 0 logmsg logMsg �  � � � I  w |�� ���
�� .ascrcmnt****      � **** � o   w x���� 0 logmsg logMsg��   �  � � � l  } }��������  ��  ��   �  � � � l  } }�� � ���   � 5 / prepare POSIX paths to php audio segmentation     � � � � ^   p r e p a r e   P O S I X   p a t h s   t o   p h p   a u d i o   s e g m e n t a t i o n   �  � � � r   } � � � � n   } � � � � 1   � ���
�� 
psxp � l  } � ����� � c   } � � � � o   } ����� 0 php_incoming_folder   � m   � ���
�� 
alis��  ��   � o      ���� 20 php_incoming_posix_path php_incoming_POSIX_path �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
psxp � l  � � ����� � c   � � � � � o   � ����� !0 php_audio_segmentation_folder   � m   � ���
�� 
alis��  ��   � o      ���� F0 !php_audio_segmentation_posix_path !php_audio_segmentation_POSIX_path �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � 4 . prepare argument for segmentation bash script    � � � � \   p r e p a r e   a r g u m e n t   f o r   s e g m e n t a t i o n   b a s h   s c r i p t �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ����� 20 php_incoming_posix_path php_incoming_POSIX_path � m   � � � � � � �  / � o   � ����� 0 current_file_name   � o      �� !0 segmentation_script_arguments   �  � � � l  � ��~�}�|�~  �}  �|   �  � � � r   � � � � � b   � � � � � b   � � � � � m   � � � � � � �  c d   � o   � ��{�{ F0 !php_audio_segmentation_posix_path !php_audio_segmentation_POSIX_path � m   � � � � � � �  ;   � o      �z�z 0 command_to_run   �  � � � r   � � � � � b   � � � � � b   � �   b   � � b   � � o   � ��y�y 0 command_to_run   m   � � �  . / o   � ��x�x 0 segmentation_script_name   m   � � �		    � o   � ��w�w !0 segmentation_script_arguments   � o      �v�v 0 command_to_run   � 

 l  � ��u�t�s�u  �t  �s   �r Q   � � O   � � I  � ��q�p
�q .coredoscnull��� ��� ctxt o   � ��o�o 0 command_to_run  �p   m   � ��                                                                                      @ alis    b  	MacOS10p6                  Ȑ!H+     �Terminal.app                                                     Y��<��        ����  	                	Utilities     Ȑ       �<��       �   �  -MacOS10p6:Applications:Utilities:Terminal.app     T e r m i n a l . a p p   	 M a c O S 1 0 p 6  #Applications/Utilities/Terminal.app   / ��   R      �n�m
�n .ascrerr ****      � **** o      �l�l 
0 errmsg  �m   k   � �  r   � � b   � � m   � � � P T e r m i n a l . a p p   r e t u r n e d   a n   e r r o r   m e s s a g e :   o   � ��k�k 
0 errmsg   o      �j�j 0 logmsg logMsg �i I  � ��h 
�h .sysodlogaskr        TEXT o   � ��g�g 0 logmsg logMsg  �f!�e
�f 
givu! o   � ��d�d 0 dialog_timeout  �e  �i  �r   � R      �c"�b
�c .ascrerr ****      � ****" o      �a�a 
0 errmsg  �b   � k   �## $%$ r   � �&'& b   � �()( m   � �** �++ � U n a b l e   t o   i n v o k e   a u d i o   s e g m e n t a t i o n   -   t h e   f u l l   e r r o r   m e s s a g e   w a s :  ) o   � ��`�` 
0 errmsg  ' o      �_�_ 0 logmsg logMsg% ,�^, I  ��]-.
�] .sysodlogaskr        TEXT- o   � �\�\ 0 logmsg logMsg. �[/�Z
�[ 
givu/ o  �Y�Y 0 dialog_timeout  �Z  �^   � 010 l �X�W�V�X  �W  �V  1 2�U2 l �T�S�R�T  �S  �R  �U  �� 0 current_file_alias   [ o   
 �Q�Q 0 added_items  ��   A 343 l     �P�O�N�P  �O  �N  4 565 i    787 I      �M9�L�M 0 load_config_properties  9 :�K: m      �J
�J 
null�K  �L  8 k     �;; <=< l     �I>?�I  > J D--------------------------------------------------------------------   ? �@@ � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -= ABA l     �HCD�H  C ) # load from config properties script   D �EE F   l o a d   f r o m   c o n f i g   p r o p e r t i e s   s c r i p tB FGF l     �GHI�G  H J D--------------------------------------------------------------------   I �JJ � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -G KLK l     �F�E�D�F  �E  �D  L MNM Q     @OPQO r    RSR c    
TUT o    �C�C ,0 configscriptfilename configScriptFilenameU m    	�B
�B 
alisS o      �A�A &0 configscriptalias configScriptAliasP R      �@�?�>
�@ .ascrerr ****      � ****�?  �>  Q Q    @VW�=V k    7XX YZY O   %[\[ r    $]^] n    "_`_ m     "�<
�< 
cfol` l    a�;�:a I    �9b�8
�9 .earsffdralis        afdrb  f    �8  �;  �:  ^ o      �7�7 0 
thisfolder 
thisFolder\ m    cc�                                                                                  MACS  alis    h  	MacOS10p6                  Ȑ!H+     �
Finder.app                                                       �:��o        ����  	                CoreServices    Ȑ       ���_       �   ?   >  0MacOS10p6:System:Library:CoreServices:Finder.app   
 F i n d e r . a p p   	 M a c O S 1 0 p 6  &System/Library/CoreServices/Finder.app  / ��  Z ded r   & 1fgf b   & /hih l  & )j�6�5j c   & )klk o   & '�4�4 0 
thisfolder 
thisFolderl m   ' (�3
�3 
TEXT�6  �5  i o   ) .�2�2 ,0 configscriptfilename configScriptFilenameg o      �1�1 &0 configscriptalias configScriptAliase m�0m r   2 7non c   2 5pqp o   2 3�/�/ &0 configscriptalias configScriptAliasq m   3 4�.
�. 
aliso o      �-�- &0 configscriptalias configScriptAlias�0  W R      �,�+�*
�, .ascrerr ****      � ****�+  �*  �=  N rsr l  A A�)�(�'�)  �(  �'  s tut r   A Hvwv I  A F�&x�%
�& .sysoloadscpt        filex o   A B�$�$ &0 configscriptalias configScriptAlias�%  w o      �#�# 0 configscript configScriptu yzy l  I I�"�!� �"  �!  �   z {|{ l  I I�}~�  } 9 3 set the amount of time before dialogs auto-answer.   ~ � f   s e t   t h e   a m o u n t   o f   t i m e   b e f o r e   d i a l o g s   a u t o - a n s w e r .| ��� r   I R��� n   I L��� o   J L�� 0 dialog_timeout  � o   I J�� 0 configscript configScript� o      �� 0 dialog_timeout  � ��� l  S S����  �  �  � ��� l  S S����  �    for php processing script   � ��� 4   f o r   p h p   p r o c e s s i n g   s c r i p t� ��� r   S \��� n   S V��� o   T V�� 0 php_processing_web_address  � o   S T�� 0 configscript configScript� o      �� 0 php_processing_web_address  � ��� l  ] ]����  �  �  � ��� r   ] f��� n   ] `��� o   ^ `�� !0 php_audio_segmentation_folder  � o   ] ^�� 0 configscript configScript� o      �� !0 php_audio_segmentation_folder  � ��� r   g p��� n   g j��� o   h j�� 0 php_incoming_folder  � o   g h�� 0 configscript configScript� o      �� 0 php_incoming_folder  � ��� l  q q��
�	�  �
  �	  � ��� r   q z��� n   q t��� o   r t�� 0 segmentation_script_name  � o   q r�� 0 configscript configScript� o      �� 0 segmentation_script_name  � ��� l  { {����  �  �  � ��� l  { {����  �   question to ask user   � ��� *   q u e s t i o n   t o   a s k   u s e r� ��� r   { ���� n   { ~��� o   | ~� �  0 alert_question  � o   { |���� 0 configscript configScript� o      ���� 0 alert_question  �  6 ��� l     ��������  ��  ��  � ��� i     ��� I      ������� 0 debug_config_properties  � ���� m      ��
�� 
null��  ��  � k     Q�� ��� l     ��������  ��  ��  � ��� r     ��� b     	��� b     ��� m     �� ��� 
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
 s s n :  � o   9 >���� 0 segmentation_script_name  � o      ���� 0 msg  � ��� l  B B��������  ��  ��  � ��� r   B E��� o   B C���� 0 msg  � o      ���� 0 logmsg logMsg� ���� I  F Q��� 
�� .sysodlogaskr        TEXT� o   F G���� 0 logmsg logMsg  ����
�� 
givu o   H M���� 0 dialog_timeout  ��  ��  �  l     ��������  ��  ��    i   ! $ I     ����
�� .ascrcmnt****      � **** l     	����	 o      ���� 0 message  ��  ��  ��   k     

  l     ����   J Dset logfile_path to "~/Library/Logs/uweAudioSegmentationDropbox.log"    � � s e t   l o g f i l e _ p a t h   t o   " ~ / L i b r a r y / L o g s / u w e A u d i o S e g m e n t a t i o n D r o p b o x . l o g "  l     ����   - 'do shell script "touch " & logfile_path    � N d o   s h e l l   s c r i p t   " t o u c h   "   &   l o g f i l e _ p a t h �� I    ����
�� .sysoexecTEXT���     TEXT b      b      b      m      � X l o g g e r   u w e A u d i o S e g m e n t a t i o n   d r o p b o x   s c r i p t :   m     �    ' o    ���� 0 message   m    !! �""  '��  ��   #��# l     ��������  ��  ��  ��       ��$ ��%&'()*+,-.��  $ �������������������������� ,0 configscriptfilename configScriptFilename�� 0 dialog_timeout  �� 0 php_processing_web_address  �� !0 php_audio_segmentation_folder  �� 0 php_incoming_folder  �� 0 alert_question  �� 0 segmentation_script_name  
�� .facofgetnull���     alis�� 0 load_config_properties  �� 0 debug_config_properties  
�� .ascrcmnt****      � ****
�� .aevtoappnull  �   � ****�� % �// F h t t p : / / 1 2 7 . 0 . 0 . 1 / a u d i o S e g m e n t a t i o n /& �00 � L o c a l H D : d e v - s n a p s h o t s : u w e A u d i o S e g m e n t a t i o n : p h p T o o l s - s r c : a u d i o S e g m e n t a t i o n' �11 � L o c a l H D : d e v - s n a p s h o t s : u w e A u d i o S e g m e n t a t i o n : p h p T o o l s - s r c : a u d i o S e g m e n t a t i o n : i n c o m i n g( �22 � D o   y o u   w a n t   t o   o p e n   a   w e b - b r o w s e r   t o   u s e   t h e   P H P   p r o c e s s i n g   i n t e r f a c e ?) �33 P i n c o m i n g - b u i l d S u b i n f o M o v e T o T r a n s c r i b e . s h* �� C����45��
�� .facofgetnull���     alis�� 0 this_folder  �� ������
�� 
flst�� 0 added_items  ��  4 
���������������������� 0 this_folder  �� 0 added_items  �� 0 current_file_alias  �� 0 current_file_name  �� 
0 errmsg  �� 0 logmsg logMsg�� 20 php_incoming_posix_path php_incoming_POSIX_path�� F0 !php_audio_segmentation_posix_path !php_audio_segmentation_POSIX_path�� !0 segmentation_script_arguments  �� 0 command_to_run  5 ���������� ��������������� � � ������� � ��� � � ���*
�� 
null�� 0 load_config_properties  
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
�� .ascrcmnt****      � ****
�� 
givu
�� .sysodlogaskr        TEXT
�� 
psxp
�� .coredoscnull��� ��� ctxt��*�k+ O�[��l kh � S ��,�&E�O��b  �&l 
W 8X  ��%�%�%b  %E�O�j O�a b  l Oa �%E�O�j UO �a E�O�j Ob  �&a ,E�Ob  �&a ,E�O�a %�%E�Oa �%a %E�O�a %b  %a %�%E�O a  �j UW X  a �%E�O�a b  l W X  a �%E�O�a b  l OP[OY�+ ��8����67���� 0 load_config_properties  �� ��8�� 8  ��
�� 
null��  6 �������� &0 configscriptalias configScriptAlias�� 0 
thisfolder 
thisFolder�� 0 configscript configScript7 ������c�������������������
�� 
alis��  ��  
�� .earsffdralis        afdr
�� 
cfol
�� 
TEXT
�� .sysoloadscpt        file�� 0 dialog_timeout  �� 0 php_processing_web_address  �� !0 php_audio_segmentation_folder  �� 0 php_incoming_folder  �� 0 segmentation_script_name  � 0 alert_question  �� � b   �&E�W 3X   %� )j �,E�UO��&b   %E�O��&E�W X  hO�j E�O��,Ec  O��,Ec  O��,Ec  O��,Ec  O��,Ec  O��,Ec  , �~��}�|9:�{�~ 0 debug_config_properties  �} �z;�z ;  �y
�y 
null�|  9 �x�w�x 0 msg  �w 0 logmsg logMsg: ��v�����u�t
�v 
ret 
�u 
givu
�t .sysodlogaskr        TEXT�{ R�b  %�%E�O��%b  %�%E�O��%b  %�%E�O��%b  %�%E�O��%b  %E�O�E�O��b  l - �s�r�q<=�p
�s .ascrcmnt****      � ****�r 0 message  �q  < �o�o 0 message  = !�n
�n .sysoexecTEXT���     TEXT�p ��%�%�%j . �m>�l�k?@�j
�m .aevtoappnull  �   � ****> k     AA  1�i�i  �l  �k  ?  @ �h�g
�h 
null�g 0 load_config_properties  �j *�k+  ascr  ��ޭ