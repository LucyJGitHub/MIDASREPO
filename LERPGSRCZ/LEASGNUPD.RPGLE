     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBI *: OVRDBF FILE(LEPARTL2X) TOFILE(LEPARTL2) SHARE(*NO)         : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Assignment update')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEASGNUPD -  Assignment Update                               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAP084             Date 02Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP070  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CAP084 - Recompiled over changed LEVASGNPD file.             *
      *           Recompiled over changed LEASGNPD format.            *
      *           Initialise numeric fields.                          *
      *  CAP070 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLEPARTL2X UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D OVRDBF          C                   'OVRDBF FILE(LEPARTL2X)-
     D                                       TOFILE(LEPARTL2) SHARE(*NO)'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Assignment Details in file format
     D LEPARTPD      E DS                  EXTNAME(LEPARTPD)
 
      ** Valid Assignment Details in file format
     D LEVASGNPD     E DS                  EXTNAME(LEVASGNPD)
 
      ** Assignment Details OK indicator
     D ASGN_OK       E DS                  EXTNAME(LEEASGNPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ** Midas API Message Header Format Definition
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_TYLC      E                     EXTFLD(TYLC)                                       CLE042
      * DATA STRUCTURE FOR SWITCHABLE FEATURE DETAILS
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CSC011          S              1A   INZ('N')
     D TRANSDTL        S           5800A
     D WTimestamp      S             26A
     D PDealNo         S             18A
     D PADealNo        S             18A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D WDealNo         S              6A
 
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
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Clear output fields
      *
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
      *                                                                         CAP084
      ** Initialise numeric fields                                              CAP084
     C                   Z-ADD     *ZEROS        ASREXR                         CAP084
     C                   Z-ADD     *ZEROS        ASPEXR                         CAP084
     C                   Z-ADD     *ZEROS        REXR                           CAP084
     C                   Z-ADD     *ZEROS        PEXR                           CAP084
 
      ** Set up the key to the assignment file
 
     C                   MOVE      ASBRCA        K#BRCA
     C                   MOVE      ASCNUM        K#PMFC
     C                   MOVE      ASFACT        K#PMFT
     C                   MOVE      ASFCNO        K#PMFN
     C                   MOVE      ASMNUM        K#MNUM
     C                   MOVE      ASINUM        K#INUM
     C                   MOVE      ASVDTC        K#VDTC
 
     C                   SELECT
 
      **  Write assignment record
      **  =======================
 
     C     S#ACTN        WHENEQ    'I'
     C                   EXSR      WRITER
 
      **  Update assignment record
      **  ========================
 
     C     S#ACTN        WHENEQ    'A'
     C                   EXSR      AMENDR
 
      **  Reverse assignment record
      **  =========================
 
     C     S#ACTN        WHENEQ    'R'
     C                   EXSR      REVERR
      *
     C                   ENDSL
 
      ** If 24x7 Midas Availability is installed, write to the standard
      ** log file when support system is active
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EXSR      ACSPFA
 
      ** Setup Assignments support log
 
     C                   CALLB     'LEASGNLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    S#ACTN
     C                   PARM                    LEPARTPD
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
     C                   PARM                    TRANSDTL
 
      ** Write to support database log file
 
     C                   IF        RetCodeOut = *BLANKS
 
     C                   EVAL      APTGTTYPE = 'LEASGN'
     C                   EVAL      APUSERID = PSUser
     C                   MOVEL     ASFRNT        APFOTRANID
     C                   MOVEL     ASAFRT        APFOASOCID
     C                   MOVEL     ASCNUM        W@ASCNUM          6
     C                   MOVEL     ASFACT        W@ASFACT          3
     C                   MOVEL     ASFCNO        W@ASFCNO          2
     C                   MOVEL     ASMNUM        W@ASMNUM          6
     C                   EVAL      PDealNo = W@ASCNUM + W@ASFACT +
     C                                       W@ASFCNO + W@ASMNUM
     C                   EVAL      PADealNo = *BLANKS
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTimestamp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo
 
     C                   ENDIF
 
      ** If error occured,
 
     C                   IF        RetCodeOut <> *BLANKS
 
     C                   EVAL      RetCodeIn = '*ERROR'
 
     C                   ENDIF
 
     C                   ENDIF
 
      **  Report any errors
 
     C     Ix            IFNE      0
     C     RetCodeIn     ANDEQ     *BLANK
     C                   MOVEL     '*ERROR    '  RetCodeIn
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Access Primary Facility                                       *
      *****************************************************************
     C     ACSPFA        BEGSR
 
     C                   CALLB     'LE002500'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Primary facility customer, type & number
     C                   PARM                    ASCNUM
     C                   PARM                    ASFACT
     C                   PARM                    ASFCNO
      *
      * OUTPUTS
      *
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
      * Prime Facility tranche/credit agreement ind
      * Prime Facility credit agreement customer, type & number
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C**********         PARM                    FccaCANM          6 0                        CSD027
     C                   PARM                    FccaCANM          6                          CSD027
     C                   PARM                    FccaCAFT          3 0
     C                   PARM                    FccaCAFN          2 0
 
      * Primary customer name & town
     C                   PARM                    S#PRNM           20
     C                   PARM                    S#PRTN           10
 
      * Agent customer number, name & town
     C                   PARM                    S#ANUM            6
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Primary facility amount edited
     C                   PARM                    S#FAMT           14
 
      * Field OK flags
     C                   PARM                    S#PMFCOK          1
     C                   PARM                    S#PMFTOK          1
     C                   PARM                    S#PMFNOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * WRITER   : Write a record to assignment file                  *
      *****************************************************************
     C     WRITER        BEGSR
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Access assignment record
 
     C     LEPARTK       CHAIN     LEPARTD0                           70
 
      ** End in error if record has been updated by another workstation
 
     C     *IN70         IFEQ      *OFF
     C                   MOVE      'N'           S#ASTSok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ASTS      'FldNameArr(Ix)
     C                   MOVEL     'LEP0026'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EWRITER
     C                   ENDIF
 
     C                   MOVEL     LEVASGNPD     LEPARTPD
     C                   EVAL      STMP  = TimeStamp
 
      * Write a record to assignment file
 
     C                   WRITE     LEPARTD0
      *
     C     EWRITER       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * AMENDR   : Update assignment File                             *
      *****************************************************************
     C     AMENDR        BEGSR
 
      ** Access assignment record
 
     C     LEPARTK       CHAIN     LEPARTD0                           70
 
      ** End in error if record has been updated by another workstation
 
     C     *IN70         IFEQ      *ON
     C                   MOVE      'N'           S#ASTSok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ASTS      'FldNameArr(Ix)
     C                   MOVEL     'LEP0026'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EAMENDR
     C                   ENDIF
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   MOVEL     LEVASGNPD     LEPARTPD
     C                   EVAL      STMP = TimeStamp
 
      ** Update assignment record
 
     C                   UPDATE    LEPARTD0
      *
     C     EAMENDR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * REVERR   : Reverse a record                                   *
      *****************************************************************
     C     REVERR        BEGSR
 
      ** Access assignment record
 
     C     LEPARTK       CHAIN     LEPARTD0                           70
      *
      ** End in error if record has been updated by another workstation
      *
     C     *IN70         IFEQ      *ON
     C                   MOVE      'N'           S#ASTSok
     C                   ADD       1             Ix
     C                   MOVEL     'S#ASTS      'FldNameArr(Ix)
     C                   MOVEL     'LEP0026'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EREVERR
     C                   ENDIF
 
      ** Delete assignment record
 
     C                   DELETE    LEPARTD0
      *
     C     EREVERR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action Code
     C                   PARM                    S#ACTN            1
 
      * Assignment Details in file format
     C                   PARM                    LEVASGNPD
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    ASGN_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
 
 
     C     *LIKE         DEFINE    BRCA          K#BRCA
     C     *LIKE         DEFINE    CNUM          K#PMFC
     C     *LIKE         DEFINE    FACT          K#PMFT
     C     *LIKE         DEFINE    FCNO          K#PMFN
     C     *LIKE         DEFINE    MNUM          K#MNUM
     C     *LIKE         DEFINE    INUM          K#INUM
     C     *LIKE         DEFINE    VDTC          K#VDTC
 
      * Key lists
 
     C     LEPARTK       KLIST
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#PMFC
     C                   KFLD                    K#PMFT
     C                   KFLD                    K#PMFN
     C                   KFLD                    K#MNUM
     C                   KFLD                    K#INUM
     C                   KFLD                    K#VDTC
 
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** OVRDBF LEPARTL2X to LEPARTL2 then OPEN LEPARTL2X
 
     C                   EVAL      LENGTH = %SIZE(OVRDBF)
     C                   CALL      'QCMDEXC'
     C                   PARM      OVRDBF        QCMD             70
     C                   PARM                    LENGTH           15 5
     C                   OPEN      LEPARTL2X
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ELSE
 
      ** Database error
 
     C                   IF        PRTCD <> '*NRF'
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
