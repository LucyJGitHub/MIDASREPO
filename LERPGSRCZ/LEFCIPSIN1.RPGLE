     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility BoE input')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFCIPSIN1- LE Facility BOE Screen Input                     *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for LE Facility BOE input.                        *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD027             Date 21Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Convert Customer Number to Alpha                    *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
     FBYFCLTY0  IF   E           K DISK    INFSR(*PSSR)
 
     FLEFCIPDSDFCF   E             WORKSTN INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      **------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     DValidFCIPEx    E DS                  EXTNAME(LEVFCIPX0)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Second DS for access progrmas, long data structure
 
     D OKFLAGS       E DS                  EXTNAME(LEEFCIPX0)
 
     D NwFCIPScnFmt  E DS                  EXTNAME(LEFCEXPD)
 
     D NwFCIPFilFmt  E DS                  EXTNAME(BYFCLTX0)
 
     D DATA            DS          1024
     D**BYCNUM*********      301    306S 0                                                    CSD027
     D  BYCNUM               301    306                                                       CSD027
     D  BYFACT               307    309S 0
     D  BYFCNO               310    311S 0
     D  BYFCCY               312    314
     D  BYEURO               315    315
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Transaction number Work Field
 
     D WKTRNN          S                   LIKE(DDTRNN)
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
 
     D RespMode        S              1A   INZ('S')
 
      ** Transaction Number
 
     D DDTRNN          S              6A
 
      ** Action Code
 
     D DDACTN          S              1A
 
      ** Build subfile
 
     D @BDSFL          S              1A
 
      ** Customer selected
 
     D @CUSEL          S              6A
 
      ** Whether position/select fields have been changed during key browse
 
     D KPosSelChg      S              1A
 
      ** Condition availability of F10 (delete)
 
     D @EINKJ          S              1A
 
      ** Error message reference
 
     D @ERRMS          S              7A
 
      ** F3 Exit
     D @INKC           S              1A
 
      ** F7 Roll backwards
 
     D @INKG           S              1A
 
      ** F8 Roll forwards
 
     D @INKH           S              1A
 
      ** F9 Insert
 
     D @INKI           S              1A
 
      ** F10 Delete
 
     D @INKJ           S              1A
 
      ** F12 Cancel
 
     D @INKL           S              1A
 
      ** Option selected
 
     D @OPSEL          S              1A
 
      ** Read backwards in roll
 
     D @RDBCK          S              1A
 
      ** Read forwards in roll
 
     D @RDFWD          S              1A
 
      ** Read next browse
 
     D @RDNB           S              1A
 
      ** Read subfile
 
     D @RDSFL          S              1A
 
     D @SCRED          S              6A
 
      ** Screen / function
 
     D @SCRN           S              1A
 
      ** Control return to key screen after F7/F8 rolls
 
     D INSERTENQ       S              1A
 
      ** Read next browse in key screen query browse subfile
 
     D K@RDNB          S              1A
 
      ** Query check in key screen customer number field
 
     D KEYQUERY        S              1A
 
      ** Mode of operation
 
     D MODEOFOP        S              6A
 
      ** Called from Customer Details or Midas menu
 
     D BrwQuery        S              1A
 
      ** Index of errors
 
     D Idx             S              3P 0
 
      ** Timestamp for the transaction
 
     D TimeStamp       S               Z
 
     D @EI             S              1    DIM(60)
     D C               S              2S 0
     D E               S              2S 0
     D ZAMSGF          S             10A
     D TEXT            S             80A
     D STITL           S             80A
     D WIdx            S              3P 0
     D W0RTN           S              7A
     D WProcess        S              1A
     D ACTN            S              1
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D SROW            S              3S 0
     D SCOL            S              3S 0
     D TITLE           S              7
     D SPARE2          S            256
     D PRTCD           S             10
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSDA          S            132
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialisation
 
     C     WKEYFLD       KLIST
     C                   KFLD                    BYCNUM
     C                   KFLD                    BYFACT
     C                   KFLD                    BYFCNO
 
     C                   EXSR      SRINIT
     C                   DOU       WProcess = 'N'
     C                   EVAL      @EI = OKFLAGS
     C                   EVAL      C = 1
     C                   EVAL      E = 50
     C                   DOU       C > 10
     C                   IF        @EI(C) = 'N' OR @EI(C) = 'W'
     C                   EVAL      *IN(E) = '1'
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
      ** Write error message to subfile
 
     C                   Z-ADD     1             C
     C     E             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZAMSID
     C                   MOVEL     MsgDtaArr(C)  ZAMSDA
     C                   EXSR      ZASNMS
     C                   ADD       1             C
     C                   ENDDO
 
      ** Write message control
 
     C                   IF        IDX > 0
     C                   WRITE     #MSGCTL
     C                   ENDIF
     C                   EXFMT     WINDOWF
 
      ** Clear message subfile
 
     C                   EXSR      SRCLEAR
     C                   EVAL      @INKC = *INKC
     C                   EVAL      @INKL = *INKL
 
      ** Initialise variables
 
     C                   EXSR      SRVCLR
 
      ** F3 was pressed
 
     C                   IF        *INKC = '1'
     C                   EXSR      SREXIT
 
      ** F12 was pressed
 
     C                   ELSEIF    *INKL = '1'
     C                   EXSR      SRPREV
 
      ** Others
 
     C                   ELSE
     C                   EXSR      SRVALID
     C                   ENDIF
     C                   ENDDO
 
     C                   EXSR      SRTERM
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM                    W0RTN
     C                   PARM                    WLEN
     C                   PARM                    WWID
     C                   PARM                    SROW
     C                   PARM                    SCOL
     C                   PARM                    TITLE
     C                   PARM                    SPARE2
 
     C                   EVAL      LVCNUM = BYCNUM
     C                   EVAL      LVFACT = BYFACT
     C                   EVAL      LVFCNO = BYFCNO
 
     C                   EVAL      SCOL=10
     C                   EVAL      SROW=10
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      ** SRINIT - INITIAL SETUP PROCESSING
      *****************************************************************
 
     C     SRINIT        BEGSR
     C                   EVAL      SWROW = SROW
     C                   EVAL      SWCOL = SCOL
     C                   EVAL      ZAMSGF = 'GBBYUSRMSG'
     C                   CALL      'SDRTVTXT'
     C                   PARM                    TITLE
     C                   PARM                    ZAMSGF
     C                   PARM                    TEXT
     C                   MOVEL     TEXT          STITL
     C                   IF        ACTN = 'E'
 
      ** IN20 is the protect indicator
 
     C                   EVAL      *IN20 = *ON
     C                   ENDIF
     C                   IF        ACTN = 'A' OR ACTN = 'E'
 
      ** Get details from BYFCLTX0
 
     C     WKEYFLD       CHAIN     BYFCLTY0
     C                   IF        %FOUND(BYFCLTY0)
     C                   EVAL      LEUROX = LEURO
     C                   EVAL      ULEURO = LEURO
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      ** SRCLEAR - CLEAR MESSAGE SUBFILE
      *****************************************************************
 
     C     SRCLEAR       BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
     C                   ENDSR
 
      *****************************************************************
      ** SREXIT - EXIT PROCESSING
      *****************************************************************
 
     C     SREXIT        BEGSR
     C                   EVAL      W0RTN = 'Y2U9999'
     C                   EVAL      WProcess = 'N'
     C                   ENDSR
 
      *****************************************************************
      ** SRPREV - RETURN TO PREVIOUS PROCESSING
      *****************************************************************
 
     C     SRPREV        BEGSR
     C                   EVAL      W0RTN = 'USR0790'
     C                   EXSR      SRCLEAR
     C                   EVAL      WProcess = 'N'
     C                   ENDSR
 
      *****************************************************************
      ** SRVCLR - CLEAR ARRAYS/FIELD INDICATORS
      *****************************************************************
 
     C     SRVCLR        BEGSR
     C                   EVAL      @EI = *ALL'0'
     C                   EVAL      OKFLAGS = *ALL'Y'
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr = *BLANKS
     C                   EVAL      MsgDtaArr = *BLANKS
     C                   EVAL      WFldNamArr = *BLANKS
     C                   EVAL      WMsgIdArr = *BLANKS
     C                   EVAL      WMsgDtaArr = *BLANKS
     C                   EVAL      W0RTN = *BLANKS
     C                   EVAL      IdX = 0
     C                   EVAL      WIdx = 0
     C                   ENDSR
 
      *****************************************************************
      ** SRVALID - VALIDATE FIELD VALUES
      *****************************************************************
 
     C     SRVALID       BEGSR
     C                   EVAL      LEUROX = ULEURO
     C                   IF        ACTN <> 'E'
     C                   CALLB     'LEFCIPVAL1'
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM                    NwFCIPScnFmt
     C                   PARM                    OKFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwFCIPFilFmt
     c                   ENDIF
     C                   EVAL      LVEURO = LEURO
     C                   EVAL      BYEURO = ULEURO
     C                   IF        IDX = 0
     C                   EVAL      WProcess = 'N'
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      ** ZASNMS - SEND MESSAGE TO PROGRAM
      *****************************************************************
 
     C     ZASNMS        BEGSR
     C                   EVAL      ##PGM = PSProcName
     C                   CALL      'Y2SNMGC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP            7
     C                   ENDSR
 
      *****************************************************************
      ** SRTERM - TERMINATE PROGRAM
      *****************************************************************
 
     C     SRTERM        BEGSR
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ****************************************************************
      /EJECT
      ****************************************************************
 
**  CPY@
(c) Finastra International Limited 2005
