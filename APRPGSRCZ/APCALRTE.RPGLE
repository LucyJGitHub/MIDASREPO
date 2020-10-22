     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Calculate Term Rate adoptation program')         *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  APCALRTE - Calculate Term Rate                               *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CSD103 *CREATE     Date 10Aug20               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      ** Fields for Return Rate conversion to screen format
     D ArrayRetr       S              1A   DIM(21)
     D IntRetr         S              5A
     D DecRetr         S             15A

      ** Parameter list for ZA0841
     D RetCodeOut      S              5A
     D @@ALPH          S             16A
     D @@MTID          S              1A
     D @@AMT           S             15  0
     D @@ERCD          S              1  0
     D @@IDP           S              3  0
     D @@IINT          S              3  0
     D BNDCSP          S              1A

      ** Input Buffer
     D I@JavaInp       DS            23
     D  I@CYCD                 1      3
     D  I@BSRC                 4      5
     D  I@CLCB                 6      6
     D  I@SDTC                 7     11
     D  I@EDTC                12     16
     D  I@LBDY                17     18
     D  I@LODY                19     20
     D  I@AVOP                21     21
     D  I@WGHT                22     22
     D  I@INED                23     23

      ** Buffer Fields
     D O@PRFG          DS             1
     D O@RETR          DS            21

      ** +--- Start of main processing -----------------------------------+

     C                   Move      *BLANKS       O@PRFG
     C                   Move      *ZEROS        O@RETRP          2015
     C                   Move      '.'           BNDCSP

     C                   Move      I@SDTC        I@SDTCZ           5 0
     C                   Move      I@EDTC        I@EDTCZ           5 0
     C                   Move      I@LBDY        I@LBDYZ           2 0
     C                   Move      I@LODY        I@LODYZ           2 0

     C                   Call      'ZACALRTE'
     C                   Parm                    I@CYCD
     C                   Parm                    I@BSRC
     C                   Parm                    I@CLCB
     C                   Parm                    I@SDTCZ
     C                   Parm                    I@EDTCZ
     C                   Parm                    I@LBDYZ
     C                   Parm                    I@LODYZ
     C                   Parm                    I@AVOP
     C                   Parm                    I@WGHT
     C                   Parm                    I@INED
     C                   Parm                    O@PRFG
     C                   Parm                    O@RETRP

     C                   Movel     O@RETRP       IntRetr
     C                   Move      O@RETRP       DecRetr
     C                   Movea     IntRetr       ArrayRetr(1)
     C                   Movea     BNDCSP        ArrayRetr(6)
     C                   Movea     DecRetr       ArrayRetr(7)

     C                   Movea     ArrayRetr     O@RETR

     C                   SetOn                                        LR
     C                   Return
      ****************************************************************
      *  Initialisation                                              *
      ****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        PList
     C                   Parm                    I@JavaInp
     C                   Parm                    O@PRFG
     C                   Parm                    O@RETR

     C                   ENDSR
      ****************************************************************
