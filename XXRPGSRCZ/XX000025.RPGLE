     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001          ')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas XX Validate RTGS Nostro for a System Value')     *
      *****************************************************************
      *                                                               *
      *  Midas - Bespoke Module                                       *
      *                                                               *
      *  XX000025 - Validate RTGS Nostro for a System Value           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. HUT110   *Create   Date 17Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT110 - Upgrade HUT022 to FBM 2.1 SP22.                     *
      *           RTGS Via SWIFT                                      *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======

      ** Midas SD Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** Extra Long Data Structure for Access Objects
     D DSLDY         E DS                  EXTNAME(DSLDY)

      ** Data structure for RTGS_Nostro string
     D RTGSNosVal      DS           200
     D  NOST01                 1      5
     D  NOST02                 6     10
     D  NOST03                11     15
     D  NOST04                16     20
     D  NOST05                21     25
     D  NOST06                26     30
     D  NOST07                31     35
     D  NOST08                36     40
     D  NOST09                41     45
     D  NOST10                46     50
     D  NOST11                51     55
     D  NOST12                56     60
     D  NOST13                61     65
     D  NOST14                66     70
     D  NOST15                71     75
     D  NOST16                76     80
     D  NOST17                81     85
     D  NOST18                86     90
     D  NOST19                91     95
     D  NOST20                96    100

      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+

      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7

      ** System value to be processed
     D SystemValue     S             20

      ** Processing mode
     D ProcMode        S            190

      ** General error indicator
     D GenError        S              1

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)

      ** Work Field for NOSTRO
     D W_NOST          S              5

      ** Array for Nostro
     D Arr_Nost        S              5    DIM(20)

      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
      *
      ** Assign each Nostro to an Array
      *
     C                   EVAL      Arr_Nost(1)  = NOST01
     C                   EVAL      Arr_Nost(2)  = NOST02
     C                   EVAL      Arr_Nost(3)  = NOST03
     C                   EVAL      Arr_Nost(4)  = NOST04
     C                   EVAL      Arr_Nost(5)  = NOST05
     C                   EVAL      Arr_Nost(6)  = NOST06
     C                   EVAL      Arr_Nost(7)  = NOST07
     C                   EVAL      Arr_Nost(8)  = NOST08
     C                   EVAL      Arr_Nost(9)  = NOST09
     C                   EVAL      Arr_Nost(10) = NOST10
     C                   EVAL      Arr_Nost(11)  = NOST11
     C                   EVAL      Arr_Nost(12)  = NOST12
     C                   EVAL      Arr_Nost(13)  = NOST13
     C                   EVAL      Arr_Nost(14)  = NOST14
     C                   EVAL      Arr_Nost(15)  = NOST15
     C                   EVAL      Arr_Nost(16)  = NOST16
     C                   EVAL      Arr_Nost(17)  = NOST17
     C                   EVAL      Arr_Nost(18)  = NOST18
     C                   EVAL      Arr_Nost(19)  = NOST19
     C                   EVAL      Arr_Nost(20) = NOST20
      *
     C                   Z-ADD     1             Ctr               2 0
     C                   Z-ADD     0             WLen              3 0
     C                   Z-ADD     0             Idx
      *
      ** Length of RTGSNosVal should be divisible by 5.
      ** If a remainder is found, there is an invalid Nostro defined,
      ** return error message and exit program.
      *
     C                   Eval      WLen = %Len(%Trim(RTGSNosVal))
     C     WLen          DIV       5             WLen
     C                   MVR                     RemChk            2 0
      *
     C                   IF        Remchk <> *Zero
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVE      'USR0374'     MsgIDXArr
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Loop through Array and Check if a Nostro entered is defined in SDNOSTPD
      *
     C                   DoW       Ctr <=WLen
     C                   Eval      W_NOST = Arr_Nost(Ctr)
      *
     C                   IF        W_NOST = *Blanks
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVE      'USR0374'     MsgIDXArr
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   EVAL      XXCYCD = %Subst(W_NOST:1:3)
     C                   EVAL      XXNONB = %Subst(W_NOST:4:2)
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       XXAPRC            7
     C                   PARM      '*KEY'        XXAPOP            7
     C                   PARM      *BLANKS       XXCUST            6
     C                   PARM                    XXCYCD            3
     C                   PARM      *BLANKS       XXACCD           10
     C                   PARM      *BLANKS       XXACSN            2
     C                   PARM                    XXNONB            2
     C                   PARM      *BLANKS       XXBRCD            3
     C                   PARM      *BLANKS       XXCSSN           10
     C                   PARM                    XXPNOI            1
     C                   PARM                    DSLDY
      *
      ** If a Nostro is not in SDNOSTPD, return error message and exit program
      *
     C                   IF        XXAPRC <> '       '
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVE      'USR0374'     MsgIDXArr
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      Ctr = Ctr + 1
     C                   ENDDO
      *
      ** Normal end processing
      *
     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    RTGSNosVal
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr
      *
      ** Check if HUT110 is on. If not, exit program
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'HUT110'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           HUT110            1
     C                   ELSE
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
