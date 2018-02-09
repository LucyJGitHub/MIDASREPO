     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Movements Status - Convert File to Screen')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEMVTSCVT - Movements Status - File to Screen          *
      *                                                               *
      *  Function:  This module converts the fields of a Movement     *
      *             Status Transaction Detail from file to screen.    *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE039  *CREATE    Date 11Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEMVTSL2  IF   E           K DISK    INFSR(*PSSR) PREFIX(P_)
     F                                     RENAME(SEMVTSD0:SEMVTSD2)
      ** Movements Status - Omit Midas-Generated Records
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
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
 
     D TranFilFmt    E DS                  EXTNAME(SEMVTSPD)
      ** SEMVTS Transaction Details in File Format
 
     D APITrnDets    E DS                  EXTNAME(SEMVTS1PD)
      ** SEMVTS Transaction Details in screen format
 
     D OScrnFlds     E DS                  EXTNAME(SEMVTS2PD)
      ** SEMVTS Output only Screen Fields
 
     D SdBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SdSCOD        E DS                  EXTNAME(SDSCODPD)
      ** SWIFT Status and Reason Codes
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Alternate arrays of Midas-generated Status Codes and Narratives
      ** and their related index
     D MidasGCod       S              4A   DIM(12) CTDATA PERRCD(1)
     D MidasGNar       S             60A   DIM(12) ALT(MidasGCod)
     D MGi             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** Set screen fields
      *
     C                   EXSR      SCREEN
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
      *
      ** Transaction Reference / WI/WO Reference
      *
     C                   IF        TMTRTY <> 'W'
     C                   EVAL      DDTRRF = TMTRRF
     C                   ELSE
     C                   EVAL      DDWIOR = TMTRRF
     C                   ENDIF
      *
      ** Transaction Type - Not on screen
      *
     C                   EVAL      DDTRTY = TMTRTY
      *
      ** Notification Date
      *
     C                   EVAL      ZDAYNO = TMNTDT
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDNTDT
      *
      ** Sequence Number
      *
     C                   MOVEL     TMSQNR        DDSQNR
      *
      ** Notification Method
      *
     C                   EVAL      DDNTMT = TMNTMT
      *
      ** SWIFT Status Code
      *
     C                   EVAL      DDSWSC = TMSWSC
      *
      ** SWIFT Reason Code
      *
     C                   EVAL      DDSWRC = TMSWRC
      *
      ** Message Key
      *
     C                   EVAL      DDMSGK = TMMSGK
      *
      ** Input Origin - Output only
      *
     C                   EVAL      DDINOR = TMINOR
      *
      ** Settlement Confirmation Requested - Not on screen
      *
     C                   EVAL      DDSCRQ = TMSCRQ
      *
      ** Settlement Message Generated - Not on screen
      *
     C                   EVAL      DDSTMG = TMSTMG
      *
      ** Narrative
      *
     C                   EVAL      DDNARR = TMNARR
      *
      ** SWIFT Status Description - Output only
      ** Midas-generated codes are tested first, and the access object
      ** is called only if not found.
      ** In this later case, and for the "RPLY" status code only, we need
      ** to replace the "xxxx" of its narrative with the status code of
      ** the first non-Midas-generated record prior to the current one.
      *
 B1  C                   IF        TMSWSC <> *Blanks
     C                   EVAL      MGi = 1
     C     TMSWSC        LOOKUP    MidasGCod(MGi)                         99
      *
 B2  C                   IF        *IN99
     C                   EVAL      DDSWSN = MidasGNar(MGi)
 X2  C                   ELSE
     C                   CALLB     'AOSCODR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      TMSWSC        @Code             4
     C                   PARM      'S'           @CdTp             1
     C                   PARM      *Blanks       @CdDp             4
     C     SdSCOD        PARM      SdSCOD        DSFDY
      *
 B3  C                   IF        @RtCd = *Blanks
      *
 B4  C                   IF        TMSWSC = 'RPLY'
     C     KSEMVTSL2_1   SETGT     SEMVTSD2
     C     KSEMVTSL2_2   READE     SEMVTSD2                               99
      *
 B5  C                   IF        NOT *IN99
     C                   EVAL      DDSWSN = %Replace(%Trim(P_TMSWSC):SRCDNR:
     C                                               %Scan('xxxx':SRCDNR):4)
 X5  C                   ELSE
     C                   EVAL      DDSWSN = %Replace('????':SRCDNR:
     C                                               %Scan('xxxx':SRCDNR):4)
 E5  C                   ENDIF
      *
 X4  C                   ELSE
     C                   EVAL      DDSWSN = SRCDNR
 E4  C                   ENDIF
      *
 X3  C                   ELSE
     C                   EVAL      DDSWSN = *ALL'?'
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** SWIFT Reason Description - Output only
      *
     C                   IF        TMSWRC <> *Blanks
     C                   CALLB     'AOSCODR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      TMSWRC        @Code             4
     C                   PARM      'R'           @CdTp             1
     C                   PARM      TMSWSC        @CdDp             4
     C     SdSCOD        PARM      SdSCOD        DSFDY
      *
     C                   IF        @RtCd = *Blanks
     C                   EVAL      DDSWRN = SRCDNR
     C                   ELSE
     C                   EVAL      DDSWRN = *ALL'?'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Last Change User - Output only
      *
     C                   EVAL      DDLCUS = TMLCUS
      *
      ** Last Change Date - Output only
      *
     C                   EVAL      ZDAYNO = TMLCDT
     C                   EXSR      ZDATE2
     C                   EVAL      DDLCDT = ZADATE
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE2 - Format a date for output
      *****************************************************************
     C     ZDATE2        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Blank outputs (EXCEPT FOR ACTION CODE)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   CLEAR                   APITrnDets
     C                   CLEAR                   OScrnFlds
     C                   MOVEL     ##ACTN        DDACTN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Transaction Details in file format
     C                   PARM                    TranFilFmt
      *
      ** OUTPUT PARAMETERS
      ** Transaction Details in screen format
     C                   PARM                    APITrnDets
      ** Output only Screen Fields
     C                   PARM                    OScrnFlds
      *
      ** Defines KLIST's
      *
     C     KSEMVTSL2_1   KLIST
     C                   KFLD                    TMTRRF
     C                   KFLD                    TMTRTY
     C                   KFLD                    TMNTDT
     C                   KFLD                    TMSQNR
      *
     C     KSEMVTSL2_2   KLIST
     C                   KFLD                    TMTRRF
     C                   KFLD                    TMTRTY
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST  '    @Optn
     C     SdBANK        PARM      SdBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *BLANK
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
**CTDATA MidasGCod
INS Inserted                                                    :
AMD Amended                                                     :
CHG Changed                                                     :
APP Approved                                                    :
AUT Authorised                                                  :
DEL Deleted                                                     :
RVD Reversed Deletion                                           :
PST Partial Settlement                                          :
RVS Reversed Settlement                                         :
SET Fully Settled                                               :
CST Contractual Settlement                                      :
VAL Validation Failure                                          :
