     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Details Screen')                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL008102 - Stamp Tax Details Screen                          *
      *                                                               *
      *  Function:  This program controls screen GL008102DF           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd 2010             *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. AR888911           Date 26Jan12               *
      *                 AR879983           Date 21Dec11               *
      *                 AR853257           Date 04Nov11               *
      *                 AR824348           Date 02Sep11               *
      *                 AR819058           Date 24Aug11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR888911 - In reversing a deal, REV column in Stamp Tax      *
      *             Movements Enquiry is not changing from N to Y     *
      *             (Recompile)                                       *
      *           - Applied for AR944923                              *
      *  AR879983 - Add stamp tax exchange rate (Recompile)           *
      *  AR853257 - Account Keys for FT were not generated            *
      *             (Recompile)                                       *
      *  AR824348 - Naming convention errors                          *
      *  AR819058 - Cheques for Collection Maintenance database error *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      *       03      F3 PRESSED EXIT PROGRAM
      *       05      F5 PRESSED REDISPLAY THE SCREEN
      *       12      F12 PRESSED GOTO PREVIOUS SCREEN
      *       20      PROTECT FIELDS
      *       21      IN ENQUIRE MODE
      *       30      NON DISPLAY DEBIT A/C NO
      *       31      NON DISPLAY STAMP TAX AMOUNT
      *       32      NON DISPLAY STAMP TAX LAST MONTH
      *       33      NON DISPLAY STAMP ON INTEREST
      *       40      REDISPLAY THE SCREEN
      *       49      INDICATES THAT CALSTX S/R IS BEING CALLED FROM UPDAT S/R
      *       5O      GENERAL ERROR INDICATOR
      *       51      STAMP TAX INDICATOR FIELD IN ERROR
      *       52      DEBIT A/C NO FIELD IN ERROR
      *       83      CHAIN TO SDSTPBPD
      *       84      CHAIN TO SDSTPCPD
      *
     FCQCOCQL0  UF A E           K DISK    COMMIT
     FCQPACQL0  UF A E           K DISK    COMMIT
     FSDSTMDL0  UF A E           K DISK    COMMIT
     FACCNT     IF   E           K DISK
     FSDBRCHEXL0IF   E           K DISK
     FSDCUSQL0  IF   E           K DISK
     F***GL8131L0  IF   E           K DISK                                                  AR824348
     FGLSTRPL0  IF   E           K DISK                                                     AR824348
     FSDSTTPL0  IF   E           K DISK
      ** Display file for screen
     FGL008102DFCF   E             WORKSTN
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D A@CPY           DS
     D** Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      ** Title
     D STITL           C                   CONST('STAMP TAX DETAILS')
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D*
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      *
      ** Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Currency Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External data structure foraccount details
      *
     D SDACNT        E DS                  EXTNAME(ACCNTAB)
      *
      ** Stamp Tax details read
      *
     D SDSTPD        E DS                  EXTNAME(SDSTPDPD)
     D                                     PREFIX(TX)
      *
     D                 DS                  INZ
     D  T#ACNO                 1     24
     D  T#DBRC                 1      3
     D  T#DCST                 4      9
     D  T#DCCY                10     12
     D  T#DACD                13     22
     D  T#DASQ                23     24
     D  T#RETL                 1     10
      *
     D DATA            DS          1024
     D  #1ATYP                19     19
     D  #1ACNO                21     30
     D  U#ORGN               201    210
     D**U#LNRF**             211    216  0                                                    CLE148
     D  U#LNRF               211    216                                                       CLE148
     D  U#FCNM               217    222
     D  U#FACT               223    225  0
     D  U#FCNO               226    227  0
     D  U#FSEQ               228    229  0
     D  U#ORED               230    234  0
     D  U#DLNO               235    240  0
     D  U#TDRF               241    246
     D  U#BRCA               247    249
     D  U#CNUM               250    255
     D  U#CCY                256    258
     D  U#ACOD               259    268  0
     D  U#ACSQ               269    270  0
     D  U#PREF               271    285
     D  U#CQSQ               286    287  0
      *
      ** The next fields are used to determine whether the Stamp Tax
      ** Indicator should be defaulted to 'Y'.
      *
     D  U#BRCH               306    308
     D  U#CUST               309    314
      *
      ** Next field used to determine if Stamp Tax Indicator may be amended.
      *
     D  U#VDAT               315    319  0
      *
      ** Next fields show the Type, Subtype and Processing type of the
      ** loan and the Facility type and the Fee Type.
      *
     D  U#TYPE               320    321
     D  U#STYP               345    346
     D  U#PTYP               347    348
     D  U#FTYP               351    353
     D  U#LFTP               354    355
      *
      ** Next fields hold amount and currency of transaction. To be
      ** used to calculate stamp tax.
      *
     D  U#AMNT               322    336  0
     D  U#TCCY               337    339
      *
     D  U#STAX               340    340
      *
      ** This field contains the Counterparty customer no. - used by
      ** Security Trades.
      *
     D  U#STCU               345    350
      *
      ** These fields are used for defaulting the Debit A/C.
      *
     D  @@CCY                356    358
     D  @@TYP1               359    359
     D  @@ACC1               360    383
     D  @@TYP2               384    384
     D  @@ACC2               385    401
      *
      ** This next field contains the apha amount from FT on which Stamp Tax is calculated on
      *
     D  U#FTAM               402    415
     D  U#FTCCY              402    404
     D  U#FTAMT              405    415  0
     D  U#VDTA               416    421
     D  U#MDTA               422    427
     D  U#CSCC               428    429
     D  U#TAXA               430    442  0
      *
     D W0DATA          DS           256
      *
      ** Calling parameter data structure
      *
     D  I#PT1                  1      1
     D  I#PTY1                 2     36
     D  I#PT2                 37     37
     D  I#PTY2                38     72
     D  I#CCY                 73     75
     D  O#CUST                76     81
     D  O#CYCD                82     84
     D  O#ACCD                85     94
     D  O#ACSN                95     96
     D  O#BRCD                97     99
      *
      ** Date
      *
     D @DATE           DS
     D  @DDAY                  1      2  0
     D  @DMON                  3      4  0
     D  @DYEA                  5      6  0
      *
      ** Work fields
      *
     D U#PERD          S              1
     D ZDATEA          S              6
     D @SCMDT          S              5  0
     D W#BTAX          S              1
     D U#DATE          S              5  0
     D U#TAXR          S             13  8
     D U#SCCY          S              3
     D U#STAF          S             13  0
     D @RUN            S              1
     D T#STLM          S                   LIKE(T#SCAI)
     D P#FRED          S                   LIKE(T#FRED)
     D P#TAX           S                   LIKE(T#TAX)
     D P#AVDT          S                   LIKE(T#AVDT)
     D P#HFDT          S                   LIKE(T#HFDT)
     D P#INDT          S                   LIKE(T#INDT)
      *
      ** Parameter fields
      *
     D Action          S              1
     D #Rtrn           S              7
     D @RTCD           S              7
     D @OPTN           S              7
     D P@ERRO          S              1
     D W0RTN           S              7
     D W0MSG           S            256
     D W#CTAX          S              1
      *
      ** SD008141 Parameter fields
      *
     D ##TYPE          S              4
     D U#CTAX          S             13  8
     D U#MTAX          S             13  8
     D U#CCCY          S              3
     D U#MCCY          S              3
     D U#MSCC          S              2
     D U#TXTY          S              1
     D @CCY            S              3
      *
      ** Y2SNMGC Parameter fields
      *
     D ZAPGMQ          S             10                                         Program queue
     D ZAPGRL          S              5                                         Rel queue
     D ZAMSID          S              7                                         Message Id
     D ZAMSGF          S             10                                         Message file
     D ZAMSDA          S            132                                         Message data
     D ZAMSTP          S              7                                         Message type
      *
      ** ZDATE2 Parameter fields
      *
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
      *
      ** ZALIGN Parameter fields
      *
     D ZRTN            S              7
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
     D ZAFLD           S             16
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
      **   Standard parameter list for window manager
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTION
     C                   PARM                    DATA
     C                   PARM                    #RTRN
      *
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      *
      ** Initialise data
      *
     C                   MOVE      *OFF          *IN72
     C                   MOVE      *OFF          *IN73
     C                   EXSR      INIT
     C     U#ORGN        IFNE      *BLANKS
      *
      ** Continue to redisplay the screen if *IN40 remains off
      *
     C     *IN40         DOUEQ     '1'
      *
      **   If error write messages
      *
     C     *IN50         IFEQ      '1'
     C                   WRITE     #MSGCTL
     C                   ENDIF
      *
      * MAIN FORMAT OF THE DISPLAY FILE
      *
     C                   EXFMT     SCREENF
     C                   EXSR      CLEAR
      *
     C     *IN03         CASEQ     '1'           EXIT
     C     *IN05         CASEQ     '1'           RESET
     C     *IN12         CASEQ     '1'           CANCEL
     C                   CAS                     VALID
     C                   ENDCS
     C                   ENDDO
     C                   ENDIF
      *
      **   Exit from program
      *
     C                   EXSR      END
      *
      *****************************************************************
      ** Subroutine  :  CLEAR                                         *
      ** Function    :  Clear Message File                            *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     CLEAR         BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  EXIT                                          *
      ** Function    :  Exit from program if F3 has been pressed      *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     EXIT          BEGSR
     C                   MOVE      'EXIT   '     #RTRN
     C                   EXSR      END
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  CANCEL                                        *
      ** Function    :  Cancel screen if F12 has been pressed         *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     CANCEL        BEGSR
      *
      ** Set F12 return code and end program
      *
     C                   MOVE      'PREV   '     #RTRN
     C                   EXSR      END
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  END                                           *
      ** Function    :  End program                                   *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     END           BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  RESET                                         *
      ** Function    :  Reset/Refresh the screen if F5 is pressed     *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     RESET         BEGSR
      *
      ** Clear the program message queue and call SR/INIT to retrieve
      ** the last committed data from the extension file.
      *
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      INIT
      *
      ** Reset all error indicators
      *
     C                   SETOFF                                       505152
     C                   SETOFF                                       53
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN59
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  INIT                                          *
      ** Function    :  Initialise fields                             *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
      **   Only do first time through
      *
     C     *IN01         IFEQ      '0'
      *
      **   Define the LDA for error handling
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C                   MOVEL     *BLANKS       U#PERD
     C                   MOVE      *ON           *IN22
     C                   MOVE      *ON           *IN24
     C                   MOVE      *ON           *IN25
     C                   MOVE      *ON           *IN26
     C                   MOVE      *ON           *IN27
     C                   MOVE      *ON           *IN28
     C                   MOVE      *ON           *IN29
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN47
     C                   MOVE      *ON           *IN48
     C                   MOVE      *BLANKS       ZDATEA
      *
     C     KLISTG        KLIST
     C                   KFLD                    U#ORGN
     C                   KFLD                    ##TYPE
     C                   KFLD                    U#LNRF
     C                   KFLD                    U#FCNM
     C                   KFLD                    U#FACT
     C                   KFLD                    U#FCNO
     C                   KFLD                    U#FSEQ
     C                   KFLD                    U#ORED
     C                   KFLD                    U#DLNO
     C                   KFLD                    U#TDRF
     C                   KFLD                    U#BRCA
     C                   KFLD                    U#CNUM
     C                   KFLD                    U#CCY
     C                   KFLD                    U#ACOD
     C                   KFLD                    U#ACSQ
     C                   KFLD                    U#PREF
     C                   KFLD                    U#CQSQ
      *
      * Determine which program screen is called from and call relevant
      * subroutine.
      *
     C                   SETON                                        01
     C                   ENDIF
      *
      ** Initialise indicators
      *
     C                   SETOFF                                       303132
     C                   SETOFF                                       33
     C*                  SETOFF                                       202122
     C                   SETOFF                                       2021
      *
      ** Call AOBANKR0 to get Midas Run Date
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     001           DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN98
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *
      ** Run Date converted to ddmmyy
      *
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
      *
      ** Move to @DATE DS (@DDAY, @DMON, @DYEA)
      *
     C                   MOVE      ZDATE         @DATE
      *
      ** Start of Current Month (@SCMDT)
      *
     C     BJDFIN        IFEQ      'D'
     C                   Z-ADD     1             @DDAY
     C                   ELSE
     C                   Z-ADD     1             @DMON
     C                   ENDIF
      *
     C**********         MOVE      @DATE         ZDATEA                                     AR819058
      *
     C**********         CALL      'ZDATEN1'                            90                  AR819058
     C**********         PARM                    ZDATEA                                     AR819058
     C**********         PARM                    ZDAYNO                                     AR819058
     C**********         PARM                    BJDFIN                                     AR819058
     C**********         PARM      *BLANKS       P@ERRO                                     AR819058
      *
     C                   MOVE      @DATE         ZDATE                                      AR819058
     C                   CALL      'ZDATE1'                                                 AR819058
     C                   PARM      *BLANKS       ZERR              7                        AR819058
     C                   PARM                    ZDATE                                      AR819058
     C                   PARM                    BJDFIN                                     AR819058
     C                   PARM      *ZEROS        ZDAYNO                                     AR819058
     C                   Z-ADD     ZDAYNO        @SCMDT
      *
     C                   MOVE      *OFF          *IN23
     C                   MOVE      'N'           T#CLO
     C                   EXSR      IOCHQ
      *
      ** Move Transaction Currency into display file field if the amount
      ** is not zero.
      ** Stamp Tax Amount
      *
     C     U#STAF        IFGT      0
     C                   MOVE      U#TCCY        T#SCAF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  IOCHQ                                         *
      ** Function    :  Processing for Stamp Tax Screen for a cheque  *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     IOCHQ         BEGSR
      *
      ** Don't display Stamp tax last month or Stamp Tax on interest
      ** or Stamp Tax Amount
      *
     C                   SETON                                        3233
     C                   SETON                                        30
     C                   SETON                                        414243
     C                   SETON                                        444546
     C                   SETON                                        4748
     C     ACTION        IFEQ      'E'
     C                   SETON                                        22
     C                   ENDIF
      *
     C     KLIST8        KLIST
     C                   KFLD                    U#PREF
     C                   KFLD                    U#CQSQ
      *
      ** If in Amend/Enquire mode - if record found on CQCOCQL0 or
      ** CQPACQL0 then move values to display fields.
      *
     C     U#ORGN        IFEQ      'CHEQC'
     C     KLIST8        CHAIN     CQCOCQL0                           80
      *
     C     *IN80         IFEQ      *OFF
     C                   MOVE      QCTAX         T#TAX
     C                   MOVE      T#TAX         P#TAX
     C     QCCDTE        IFLT      BJRDNB
     C                   SETON                                        20
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C     KLIST8        CHAIN     CQPACQL0                           80
      *
     C     *IN80         IFEQ      *OFF
     C                   MOVE      QPTAX         T#TAX
     C                   MOVE      T#TAX         P#TAX
     C     QPCDTE        IFLT      BJRDNB
     C                   SETON                                        20
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If record not found on CQCOCQL0/CQPACQL0 in Enquire mode
      ** then end program, otherwise protect input fields and ensure
      ** correct fields are Non-Display
      *
     C     ACTION        IFEQ      'E'
     C     *IN80         IFEQ      *ON
     C                   EXSR      END
     C                   ELSE
     C                   SETON                                        202122
     C                   ENDIF
     C                   ENDIF
      *
      ** If not found on CQCOCQL0/CQPACQL0
      *
     C     *IN80         IFEQ      *ON
      *
      ** Default Stamp Tax Indicator Screen field
      *
     C                   EXSR      STCUS
      *
     C                   EXSR      STBRA
      *
      ** If both branch and customer are set up to be liable for Stamp
      ** Tax then default the screen field tax indicator to 'Y'and
      ** default the Account to be the details returned from GL008101.
      *
     C     W#BTAX        IFEQ      'Y'
     C     W#CTAX        ANDEQ     'Y'
     C                   MOVE      'Y'           T#TAX
     C                   ELSE
     C                   MOVE      'N'           T#TAX
     C                   ENDIF
     C                   MOVE      *BLANKS       P#TAX
     C*****              MOVE      *OFF          *IN27
      *
     C                   ENDIF
      *
      ** Calculate the Stamp Tax and display on the screen. Do not process this after
      ** the display though as this is for information only.
      *
     C                   EXSR      CALSTX
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  UPDAT                                         *
      ** Function    :  Update the extension file                     *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     UPDAT         BEGSR
      *
     C     *IN80         IFEQ      *ON
      *
     C     U#ORGN        IFEQ      'CHEQC'
     C                   MOVE      T#TAX         QCTAX
     C                   Z-ADD     BJRDNB        QCCDTE
     C                   MOVE      U#PREF        QCPREF
     C                   MOVE      U#CQSQ        QCCQSQ
     C                   Z-ADD     U#STAF        QCSTAF
     C                   EXSR      HISUPD
     C                   WRITE     CQCOCQD0
     C                   ELSE
     C                   MOVE      T#TAX         QPTAX
     C                   Z-ADD     BJRDNB        QPCDTE
     C                   MOVE      U#PREF        QPPREF
     C                   MOVE      U#CQSQ        QPCQSQ
     C                   Z-ADD     U#STAF        QPSTAF
     C                   EXSR      HISUPD
     C                   WRITE     CQPACQD0
     C                   ENDIF
      *
     C                   ELSE
      *
      ** RECORD CURRENTLY EXISTS SO NEED TO UPDATE
      *
     C     U#ORGN        IFEQ      'CHEQC'
     C*
     C     KLIST8        CHAIN     CQCOCQL0                           82
     C                   MOVE      T#TAX         QCTAX
     C                   Z-ADD     BJRDNB        QCCDTE
     C                   Z-ADD     U#STAF        QCSTAF
     C                   EXSR      HISUPD
     C                   UPDATE    CQCOCQD0
     C*
     C                   ELSE
     C     KLIST8        CHAIN     CQPACQL0                           82
     C                   MOVE      T#TAX         QPTAX
     C                   Z-ADD     BJRDNB        QPCDTE
     C                   Z-ADD     U#STAF        QPSTAF
     C                   EXSR      HISUPD
     C                   UPDATE    CQPACQD0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  VALID                                         *
      ** Function    :  Validate the screen                           *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     VALID         BEGSR
      *
      ** If the action code is Enquire then simply exit from the program
      *
     C     ACTION        IFEQ      'E'
     C                   EXSR      END
     C                   ENDIF
      *
      ** IF ACTION CODE IS AMEND OR INSERT
      ** Set error indicators to be OFF
      *
     C                   SETOFF                                       505152
     C                   SETOFF                                       53
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN59
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
      *
      ** Validate Stamp Tax Indicator
      *
     C                   EXSR      VALTAX
      *
      ** If there are any errors *IN40 must be set off, otherwise set *IN40 on.
      *
     C     *IN50         IFEQ      *ON
     C                   SETOFF                                       40
     C                   ELSE
     C                   SETON                                        40
     C                   ENDIF
      *
      ** If there is an error in any of the fields then need to
      ** redisplay the screen and send all error messages
      *
     C     *IN40         IFEQ      '1'
      *
      ** No errors so update the extension file
      *
     C                   EXSR      UPDAT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  VALTAX                                        *
      ** Function    :  Validate Stamp Tax Indicator                  *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     VALTAX        BEGSR
      *
     C     T#TAX         IFNE      'Y'
     C     T#TAX         ANDNE     'N'
     C                   SETON                                        5051
      *
      ** Send message 'Tax Indicator must be 'Y' or 'N''
      *
     C                   MOVEL     'USR9478'     ZAMSID
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
     C                   ELSE
      *
      ** Stamp tax indicator can't be 'Y' if booking branch is not taxable
      *
     C     T#TAX         IFEQ      'Y'
     C     W#BTAX        ANDEQ     'N'
     C                   SETON                                        5051
     C                   MOVEL     'USR9479'     ZAMSID
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      ** Stamp tax indicator can't be 'Y' if debit party  customer is not taxable
      *
     C     T#TAX         IFEQ      'Y'
     C     W#CTAX        ANDEQ     'N'
     C                   SETON                                        5051
     C                   MOVEL     'USR9480'     ZAMSID
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      ** Move Tax field into U#STAX. This is a parameter passed back to
      ** determine whether tax is to be calculated.
      *
     C                   MOVE      T#TAX         U#STAX
     C                   ENDIF
      *
      ** If Main Stamp Tax Flag is N - set Tax Amount to 0.
      *
     C     *IN50         IFNE      *ON
     C     T#TAX         ANDNE     'Y'
     C                   CLEAR                   T#STAF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  STBRA                                         *
      ** Function    :  See if relevant Branch is set up to be liable *
      **                for Stamp Tax                                 *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     STBRA         BEGSR
      *
      ** Set up KLIST to chain to Stamp Tax Defaults by branch file
      ** and see if branch is set up to be liable to stamp tax.
      *
     C     KLBRCH        KLIST
     C                   KFLD                    U#BRCH
      *
     C     KLBRCH        CHAIN     SDBRCHEXL0                         83
      *
      ** If record found and Branch is set up to be liable to stamp tax
      ** move Y to temp field W#BRCH. Otherwsie move N to W#BRCH.
      *
     C     *IN83         IFEQ      *OFF
     C     BXTAX         IFEQ      'Y'
     C                   MOVE      'Y'           W#BTAX
     C                   ELSE
     C                   MOVE      'N'           W#BTAX
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           W#BTAX
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  STCUS                                         *
      ** Function    :  See if Customer is liable to Stamp Tax        *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     STCUS         BEGSR
      *
      ** If account information passed then get account and customer
      ** using GL008101
      *
     C     @@CCY         IFNE      *BLANKS
     C                   CLEAR                   W0DATA
     C                   MOVEL(P)  @@TYP1        I#PT1
     C                   MOVEL(P)  @@ACC1        I#PTY1
     C                   MOVEL(P)  @@TYP2        I#PT2
     C                   MOVEL(P)  @@ACC2        I#PTY2
     C                   MOVEL(P)  @@CCY         I#CCY
      *
     C                   CALL      'GL008101'
     C                   PARM                    W0RTN
     C                   PARM                    W0DATA
     C                   PARM                    W0MSG
      *
      ** Move Customer and branch into fields to CHAIN to files to see if
      ** liable to Stamp Tax.
      *
     C                   MOVEL     O#CUST        U#CUST
     C                   MOVEL     O#BRCD        U#BRCH
     C                   ENDIF
      *
      ** Set up KLIST to chain to Stamp Tax Defaults by customer file
      ** and see if customer is set up to be liable to stamp tax.
      *
     C     KLCUST        KLIST
     C                   KFLD                    U#CUST
      *
     C     KLCUST        CHAIN     SDCUSQL0                           84
      *
      ** If record found and Customer is set up to be liable to stamp
      ** tax move Y to temp field W#CTAX. Otherwise move N to W#CTAX.
      *
     C     *IN84         IFEQ      *OFF
     C     CQTAX         IFEQ      'Y'
     C                   MOVE      'Y'           W#CTAX
     C                   ELSE
     C                   MOVE      'N'           W#CTAX
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           W#CTAX
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  CALSTX                                        *
      ** Function    :  Calculate Stamp Tax                           *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     CALSTX        BEGSR
      *
     C                   MOVE      U#VDAT        U#DATE
     C                   MOVE      *BLANKS       U#TXTY
      *
      ** SD008141 will return the Tax Rate to be used to calculate the
      ** Stamp Tax and the Stamp Tax Currency
      *
     C                   CALL      'SD008141'
     C                   PARM                    U#DATE
     C                   PARM                    U#ORGN
     C                   PARM                    ##TYPE
     C                   PARM                    U#CTAX
     C                   PARM                    U#MTAX
     C                   PARM                    U#CCCY
     C                   PARM                    U#MCCY
     C                   PARM                    U#CSCC
     C                   PARM                    U#MSCC
     C                   PARM                    U#TXTY
     C                   PARM                    SDSTPD
      *
      ** If there is a default for the Module use this tax rate and ccy
      ** otherwise use the ICD Control defaults.
      *
     C     U#MTAX        IFNE      *ZEROS
     C                   Z-ADD     U#MTAX        U#TAXR
     C                   MOVE      U#MCCY        U#SCCY
     C                   ELSE
     C                   Z-ADD     U#CTAX        U#TAXR
     C                   MOVE      U#CCCY        U#SCCY
     C                   ENDIF
      *
     C     U#AMNT        MULT(H)   U#TAXR        U#STAF
     C     T#TAX         IFEQ      'N'
     C                   Z-ADD     *ZERO         U#STAF
     C                   ENDIF
      *
      ** If This routine has been called from UPDAT S/R then don't call
      ** ZEDIT as amount is being written to file, not displayed.
      *
     C     *IN49         IFEQ      *ON
     C     U#ORGN        IFEQ      'CHEQC'
     C                   MOVE      U#STAF        QCSTAF
     C                   ELSE
     C                   MOVE      U#STAF        QPSTAF
     C                   ENDIF
     C                   ELSE
     C                   EXSR      CSTNTA
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  CSTNTA                                        *
      ** Function    :  Convert Stamp Tax Amount from numeric to      *
      **                alphanumeric                                  *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     CSTNTA        BEGSR
      *
      ** Determine number of decimal places for transaction currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      U#TCCY        @CCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     002           DBASE
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     U#TCCY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   SELECT
     C     A6NBDP        WHENEQ    0
     C                   MOVE      '0'           ZADEC
     C     A6NBDP        WHENEQ    1
     C                   MOVE      '1'           ZADEC
     C     A6NBDP        WHENEQ    2
     C                   MOVE      '2'           ZADEC
     C     A6NBDP        WHENEQ    3
     C                   MOVE      '3'           ZADEC
     C                   ENDSL
      *
     C                   MOVE      U#STAF        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        T#STAF
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  TAXUPD                                        *
      ** Function    :  To update Tax fields on file if Tax Due       *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     TAXUPD        BEGSR
      *
     C     T#TAX         IFEQ      'Y'
      *
      ** Need to calculate the stamp tax here as the Stamp Tax Liable field
      ** may have been amended from 'N' to 'Y'.
      *
     C                   SETON                                        49
     C                   EXSR      CALSTX
     C                   ELSE
     C     U#ORGN        IFEQ      'CHEQC'
     C                   Z-ADD     0             QCSTAF
     C                   ELSE
     C                   Z-ADD     0             QPSTAF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  HISUPD                                        *
      ** Function    :  To update Stamp Tax Historic Details File     *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     HISUPD        BEGSR
      *
      ** If record already exists move required fields into file fields
      ** and update, otherwise move required fields (including key
      ** fields) into file fields and write.
      *
     C                   MOVE      *BLANKS       ##TYPE
      *
     C     KLISTG        CHAIN     SDSTMDL0                           85
     C     *IN85         IFEQ      *OFF
     C                   EXSR      HISMOV
     C                   UPDATE    @STMDV0
     C                   ELSE
      *
     C     U#ORGN        IFEQ      'CHEQC'
     C                   MOVEL     'CHEQC'       T2KEY
     C                   MOVE      QCPREF        T2PREF
     C                   MOVE      QCCQSQ        T2CQSQ
     C                   ELSE
     C                   MOVEL     'CHEQP'       T2KEY
     C                   MOVE      QPPREF        T2PREF
     C                   MOVE      QPCQSQ        T2CQSQ
     C                   ENDIF
     C                   MOVE      *BLANKS       T2LNRF
     C                   MOVE      *BLANKS       T2FCNM
     C                   MOVE      *BLANKS       T2FACT
     C                   MOVE      *BLANKS       T2FCNO
     C                   MOVE      *BLANKS       T2FSEQ
     C                   MOVE      *BLANKS       T2ORED
     C                   MOVE      *BLANKS       T2DLNO
     C                   MOVE      'Y'           T2STFC
     C                   EXSR      HISMOV
     C                   WRITE     @STMDV0
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  HISMOV                                        *
      ** Function    :  Move Fields to output to Stamp Tax Historic   *
      **                Details File                                  *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     HISMOV        BEGSR
      *
     C                   MOVE      'T'           T2RCTP
     C                   MOVE      T#TAX         T2TCAL
     C                   MOVE      U#TAXR        T2TXRT
     C                   MOVE      U#PERD        T2PERD
     C                   MOVE      U#TCCY        T2ECCY
     C                   MOVE      U#SCCY        T2SCCY
     C                   MOVE      U#STAF        T2TATC
     C                   MOVE      *BLANKS       T2STFF
      *
     C     *IN85         IFEQ      *OFF
     C                   MOVE      'A'           T2TYLC
     C                   ELSE
     C                   MOVE      'I'           T2TYLC
     C                   ENDIF
     C                   MOVE      BJRDNB        T2LCD
     C                   MOVE      O#CUST        T2DCST
     C                   MOVE      O#CYCD        T2DCCY
     C                   MOVE      O#BRCD        T2DBRC
     C                   MOVE      O#ACCD        T2DACD
     C                   MOVE      O#ACSN        T2DASQ
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  ZASNMS                                        *
      ** Function    :  Send message to program's message queue.      *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *
     C     ZAEXIT        ENDSR
      *
      *****************************************************************
      ** Subroutine  :  ZDATE2                                        *
      ** Function    :  Format a date for output                      *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     ZDATE2        BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  SRALGN                                        *
      ** Function    :  Format amount                                 *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     SRALGN        BEGSR
      *
     C                   CALL      'ZALIGN'                             90
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   PARM      *BLANKS       ZAFLD
      *
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  ZEDIT                                         *
      ** Function    :  Edit an unsigned field                        *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     ZEDIT         BEGSR
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   ENDSR
      *
      *****************************************************************
      ** Subroutine  :  *PSSR                                         *
      ** Function    :  Program exception error routine.              *
      ** Called by   :                                                *
      ** Calls       :                                                *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
