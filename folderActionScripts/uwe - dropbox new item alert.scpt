FasdUAS 1.101.10   ��   ��    k             l      ��  ��    j d
this code is descended from Apple sample code.
The original script was "add - new item alert.scpt"
     � 	 	 � 
 t h i s   c o d e   i s   d e s c e n d e d   f r o m   A p p l e   s a m p l e   c o d e . 
 T h e   o r i g i n a l   s c r i p t   w a s   " a d d   -   n e w   i t e m   a l e r t . s c p t " 
   
  
 l     ��������  ��  ��        l     ��  ��    J D--------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��  ��    ) # load from config properties script     �   F   l o a d   f r o m   c o n f i g   p r o p e r t i e s   s c r i p t      l     ��  ��    J D--------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      j     �� �� ,0 configscriptfilename configScriptFilename  m        �   8 u w e   -   c o n f i g   p r o p e r t i e s . s c p t     !   l     ��������  ��  ��   !  " # " l    @ $���� $ Q     @ % & ' % r     ( ) ( c    
 * + * o    ���� ,0 configscriptfilename configScriptFilename + m    	��
�� 
alis ) o      ���� &0 configscriptalias configScriptAlias & R      ������
�� .ascrerr ****      � ****��  ��   ' Q    @ , -�� , k    7 . .  / 0 / O   % 1 2 1 r    $ 3 4 3 n    " 5 6 5 m     "��
�� 
cfol 6 l     7���� 7 I    �� 8��
�� .earsffdralis        afdr 8  f    ��  ��  ��   4 o      ���� 0 
thisfolder 
thisFolder 2 m     9 9�                                                                                  MACS  alis    `  vb_osx                     ɱM?H+     �
Finder.app                                                       ��ǵ�        ����  	                CoreServices    ɱM?      ǵ�       �   D   C  -vb_osx:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    v b _ o s x  &System/Library/CoreServices/Finder.app  / ��   0  : ; : r   & 1 < = < b   & / > ? > l  & ) @���� @ c   & ) A B A o   & '���� 0 
thisfolder 
thisFolder B m   ' (��
�� 
TEXT��  ��   ? o   ) .���� ,0 configscriptfilename configScriptFilename = o      ���� &0 configscriptalias configScriptAlias ;  C�� C r   2 7 D E D c   2 5 F G F o   2 3���� &0 configscriptalias configScriptAlias G m   3 4��
�� 
alis E o      ���� &0 configscriptalias configScriptAlias��   - R      ������
�� .ascrerr ****      � ****��  ��  ��  ��  ��   #  H I H l     ��������  ��  ��   I  J K J l  A H L���� L r   A H M N M I  A F�� O��
�� .sysoloadscpt        file O o   A B���� &0 configscriptalias configScriptAlias��   N o      ���� 0 configscript configScript��  ��   K  P Q P l     ��������  ��  ��   Q  R S R l     �� T U��   T 9 3 set the amount of time before dialogs auto-answer.    U � V V f   s e t   t h e   a m o u n t   o f   t i m e   b e f o r e   d i a l o g s   a u t o - a n s w e r . S  W X W l  I N Y���� Y r   I N Z [ Z n   I L \ ] \ o   J L���� 0 dialog_timeout   ] o   I J���� 0 configscript configScript [ o      ���� 0 dialog_timeout  ��  ��   X  ^ _ ^ l     ��������  ��  ��   _  ` a ` l     �� b c��   b    for php processing script    c � d d 4   f o r   p h p   p r o c e s s i n g   s c r i p t a  e f e l  O T g���� g r   O T h i h n   O R j k j o   P R���� 0 php_incoming_folder   k o   O P���� 0 configscript configScript i o      ���� 0 php_incoming_folder  ��  ��   f  l m l l  U Z n���� n r   U Z o p o n   U X q r q o   V X���� 0 php_processing_web_address   r o   U V���� 0 configscript configScript p o      ���� 0 php_processing_web_address  ��  ��   m  s t s l     ��������  ��  ��   t  u v u l     �� w x��   w   question to ask user    x � y y *   q u e s t i o n   t o   a s k   u s e r v  z { z l  [ ` |���� | r   [ ` } ~ } n   [ ^  �  o   \ ^���� 0 alert_question   � o   [ \���� 0 configscript configScript ~ o      ���� 0 alert_question  ��  ��   {  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �   debug    � � � �    d e b u g �  � � � l  a | ����� � I  a |�� ���
�� .sysodlogaskr        TEXT � b   a x � � � b   a v � � � b   a r � � � b   a n � � � b   a l � � � b   a h � � � b   a d � � � m   a b � � � � � 
 p i f :   � o   b c���� 0 php_incoming_folder   � o   d g��
�� 
ret  � m   h k � � � � �  p p w a :   � o   l m���� 0 php_processing_web_address   � o   n q��
�� 
ret  � m   r u � � � � �  a q :   � o   v w���� 0 alert_question  ��  ��  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � J D--------------------------------------------------------------------    � � � � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - �  � � � l     �� � ���   �   begin code    � � � �    b e g i n   c o d e �  � � � l     �� � ���   � J D--------------------------------------------------------------------    � � � � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - �  � � � l     ��������  ��  ��   �  ��� � i     � � � I     �� � �
�� .facofgetnull���     alis � o      ���� 0 this_folder   � �� ���
�� 
flst � o      ���� 0 added_items  ��   � Q     � � ��� � k    � � �  � � � l   ��������  ��  ��   �  � � � O     � � � k     � �  � � � l   �� � ���   �   get the name of the folder    � � � � 4 g e t   t h e   n a m e   o f   t h e   f o l d e r �  � � � r     � � � l   
 ����� � n    
 � � � 1    
��
�� 
pnam � o    ���� 0 this_folder  ��  ��   � l      ����� � o      ���� 0 folder_name  ��  ��   �  � � � l   ��������  ��  ��   �  � � � l   �� � ���   � " show the items in the folder    � � � � 8 s h o w   t h e   i t e m s   i n   t h e   f o l d e r �  � � � l   �� � ���   �  open this_folder    � � � �   o p e n   t h i s _ f o l d e r �  � � � l   �� � ���   �  reveal the added_items    � � � � , r e v e a l   t h e   a d d e d _ i t e m s �  � � � l   ����~��  �  �~   �  � � � l   �} � ��}   � ' ! move the items to the php folder    � � � � B   m o v e   t h e   i t e m s   t o   t h e   p h p   f o l d e r �  ��| � I   �{ � �
�{ .coremoveobj        obj  � o    �z�z 0 added_items   � �y ��x
�y 
insh � o    �w�w 0 php_incoming_folder  �x  �|   � m     � ��                                                                                  MACS  alis    `  vb_osx                     ɱM?H+     �
Finder.app                                                       ��ǵ�        ����  	                CoreServices    ɱM?      ǵ�       �   D   C  -vb_osx:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    v b _ o s x  &System/Library/CoreServices/Finder.app  / ��   �  � � � l   �v�u�t�v  �u  �t   �  � � � l   �s�r�q�s  �r  �q   �  � � � l   �p � ��p   � A ; find out how many new items have been placed in the folder    � � � � v   f i n d   o u t   h o w   m a n y   n e w   i t e m s   h a v e   b e e n   p l a c e d   i n   t h e   f o l d e r �  � � � r     � � � l    ��o�n � n     � � � m    �m
�m 
nmbr � n    � � � 2   �l
�l 
cobj � l    ��k�j � o    �i�i 0 added_items  �k  �j  �o  �n   � l      �h�g  o      �f�f 0 
item_count  �h  �g   �  l   �e�e    create the alert string    � . c r e a t e   t h e   a l e r t   s t r i n g  r    '	 c    %

 l   #�d�c b    # b    ! m     � * F o l d e r   A c t i o n s   A l e r t : o     �b
�b 
ret  o   ! "�a
�a 
ret �d  �c   m   # $�`
�` 
utxt	 o      �_�_ 0 alert_message    Z   ( ?�^ ?  ( + l  ( )�]�\ o   ( )�[�[ 0 
item_count  �]  �\   m   ) *�Z�Z  r   . 7 b   . 5 b   . 3  o   . /�Y�Y 0 alert_message    l  / 2!�X�W! c   / 2"#" l  / 0$�V�U$ o   / 0�T�T 0 
item_count  �V  �U  # m   0 1�S
�S 
ctxt�X  �W   m   3 4%% �&&    n e w   i t e m s   o      �R�R 0 alert_message  �^   r   : ?'(' b   : =)*) o   : ;�Q�Q 0 alert_message  * m   ; <++ �,,  O n e   n e w   i t e m  ( o      �P�P 0 alert_message   -.- r   @ M/0/ b   @ K121 b   @ I343 b   @ G565 b   @ E787 b   @ C9:9 o   @ A�O�O 0 alert_message  : m   A B;; �<< $ p l a c e d   i n     f o l d e r  8 m   C D== utxt 6 l  E F>�N�M> o   E F�L�L 0 folder_name  �N  �M  4 m   G H?? utxt 2 m   I J@@ �AA  .0 o      �K�K 0 alert_message  . BCB r   N WDED l  N UF�J�IF b   N UGHG b   N SIJI b   N QKLK l  N OM�H�GM o   N O�F�F 0 alert_message  �H  �G  L o   O P�E
�E 
ret J o   Q R�D
�D 
ret H o   S T�C�C 0 alert_question  �J  �I  E l     N�B�AN o      �@�@ 0 alert_message  �B  �A  C OPO l  X X�?�>�=�?  �>  �=  P QRQ l  X X�<ST�<  S 0 * determine what the user would like to do    T �UU T   d e t e r m i n e   w h a t   t h e   u s e r   w o u l d   l i k e   t o   d o  R VWV I  X v�;XY
�; .sysodlogaskr        TEXTX l  X YZ�:�9Z o   X Y�8�8 0 alert_message  �:  �9  Y �7[\
�7 
btns[ J   \ d]] ^_^ m   \ _`` �aa  Y e s_ b�6b m   _ bcc �dd  N o�6  \ �5ef
�5 
dflte m   g h�4�4 f �3gh
�3 
dispg m   k l�2�2 h �1i�0
�1 
givui o   o p�/�/ 0 dialog_timeout  �0  W jkj r   w �lml l  w ~n�.�-n n   w ~opo 1   z ~�,
�, 
bhitp l  w zq�+�*q 1   w z�)
�) 
rslt�+  �*  �.  �-  m l     r�(�'r o      �&�& 0 user_choice  �(  �'  k s�%s Z   � �tu�$�#t =  � �vwv o   � ��"�" 0 user_choice  w m   � �xx �yy  Y e su I  � ��!z� 
�! .GURLGURLnull��� ��� TEXTz o   � ��� 0 php_processing_web_address  �   �$  �#  �%   � R      ���
� .ascrerr ****      � ****�  �  ��  ��       �{ |}�  { ���� ,0 configscriptfilename configScriptFilename
� .facofgetnull���     alis
� .aevtoappnull  �   � ****| � ���~�
� .facofgetnull���     alis� 0 this_folder  � ���
� 
flst� 0 added_items  �  ~ 
�������
�	��� 0 this_folder  � 0 added_items  � 0 folder_name  � 0 php_incoming_folder  � 0 
item_count  � 0 alert_message  �
 0 alert_question  �	 0 dialog_timeout  � 0 user_choice  � 0 php_processing_web_address    �������� ��%+;=?@��`c��������������x������
� 
pnam
� 
insh
� .coremoveobj        obj 
� 
cobj
� 
nmbr
� 
ret 
�  
utxt
�� 
ctxt
�� 
btns
�� 
dflt
�� 
disp
�� 
givu�� 
�� .sysodlogaskr        TEXT
�� 
rslt
�� 
bhit
�� .GURLGURLnull��� ��� TEXT��  ��  � � �� ��,E�O��l UO��-�,E�O��%�%�&E�O�k ���&%�%E�Y ��%E�O��%�%�%�%�%E�O��%�%�%E�O�a a a lva la ka �a  O_ a ,E�O�a   
�j Y hW X  h} �����������
�� .aevtoappnull  �   � ****� k     |��  "��  J��  W��  e��  l��  z��  �����  ��  ��  �  � �������� 9�������������������� ��� � ���
�� 
alis�� &0 configscriptalias configScriptAlias��  ��  
�� .earsffdralis        afdr
�� 
cfol�� 0 
thisfolder 
thisFolder
�� 
TEXT
�� .sysoloadscpt        file�� 0 configscript configScript�� 0 dialog_timeout  �� 0 php_incoming_folder  �� 0 php_processing_web_address  �� 0 alert_question  
�� 
ret 
�� .sysodlogaskr        TEXT�� } b   �&E�W 3X   %� )j �,E�UO��&b   %E�O��&E�W X  hO�j 	E�O��,E�O��,E�O��,E�O��,E�O��%_ %a %�%_ %a %�%j ascr  ��ޭ