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

     D O@RETRP         S             20P15
     D I@SDTCZ         S              5S 0
     D I@EDTCZ         S              5S 0
     D I@LBDYZ         S              2S 0
     D I@LODYZ         S              2S 0

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
     D O@RETR          DS            22

      ** +--- Start of main processing -----------------------------------+

     C                   MOVE      *BLANKS       O@PRFG
     C                   MOVE      *ZEROS        O@RETRP

     C                   MOVE      I@SDTC        I@SDTCZ
     C                   MOVE      I@EDTC        I@EDTCZ
     C                   MOVE      I@LBDY        I@LBDYZ
     C                   MOVE      I@LODY        I@LODYZ

     C                   CALL      'ZACALRTE'
     C                   PARM                    I@CYCD
     C                   PARM                    I@BSRC
     C                   PARM                    I@CLCB
     C                   PARM                    I@SDTCZ
     C                   PARM                    I@EDTCZ
     C                   PARM                    I@LBDYZ
     C                   PARM                    I@LODYZ
     C                   PARM                    I@AVOP
     C                   PARM                    I@WGHT
     C                   PARM                    I@INED
     C                   PARM                    O@PRFG
     C                   PARM                    O@RETRP

     C                   EVAL      O@RETR = %CHAR(O@RETRP)

     C                   SETON                                        LR
     C                   RETURN
      ****************************************************************
      *  Initialisation                                              *
      ****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    I@JavaInp
     C                   PARM                    O@PRFG
     C                   PARM                    O@RETR

     C                   ENDSR
      ****************************************************************

