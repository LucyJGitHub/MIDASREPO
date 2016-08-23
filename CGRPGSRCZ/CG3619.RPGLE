     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Schema & elmnt names MNT paths conversion')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3619 - Schema and Element names maintenance                *
      *           Paths Conversion List                               *
      *                                                               *
      *  Function:  This program lists all the paths (and its         *
      *             corresponding Element Name) generated for the     *
      *             Group Set passed by calling program CG3618. It    *
      *             will call CG3620 when a record is selected for    *
      *             enquiry or amendment.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *  Last Amend No. 211237             Date 28Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 09Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  211237 - Paths incorrectly displayed                         *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Subfile Display                                 *
      *    02         Subfile Clear                                   *
      *    03         Subfile Next change                             *
      *    04         Display Attributes of Position field #0POSI     *
      *    05         Display Attributes of Selection field #0SELE    *
      *    07         Subfile End                                     *
      *    08         Enable/Disable RollUp key                       *
      *    09         RollUp key has been pressed                     *
      *    10         No Details to Process                           *
      *    11         End of file/No record found                     *
      *    12         End of file/No record found                     *
      *    13         General purpose indicator                       *
      *    14         General purpose indicator                       *
      *                                                               *
      *    90-99      Used by Standard Subroutines                    *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRBUILD - Build subfile                                      *
      *  SRCMPLX - Handles complex paths                              *
      *  SRERROR - Handles error messages                             *
      *  SRINIT  - Initialisation                                     *
      *  SRRASC  - Get RDEs from RDEs Associations file CGRASCPD      *
      *  SRRFRSH - Refresh Subfile                                    *
      *  SRRVIEW - Position subfile on path entered                   *
      *  SRVALD  - Validate Selection Option entered                  *
      *  SRWRITE - Writes to array AGenPath                           *
      *  *INSZR  - Initialisation routine                             *
      *  *PSSR   - Program Error Processing Subroutine                *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FCGGSASL1  IF   E           K DISK    INFSR(*PSSR)
     FCGRASCL1  IF   E           K DISK    INFSR(*PSSR)
     FCGGSETL1  IF   E           K DISK    INFSR(*PSSR)
     FCGRDECL0  IF   E           K DISK    INFSR(*PSSR)
     FCG3619DF  CF   E             WORKSTN
     F                                     SFILE(CG3619S0:Wrrn)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     DSDBANK         E DS                  EXTNAME(SDBANKPD)
      ** Data Structure to hold Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First Data Structure for Access Objects
 
     DAGenPath         S             70A   DIM(999) ASCEND
      ** Array to store the paths generated
 
     DAFrmGrp          S              6A   DIM(10) INZ(*BLANKS)
      ** Array to function as stack and save From Linked Grp Sets
 
     DAToGrp           S              6A   DIM(10) INZ(*BLANKS)
      ** Array to function as stack and save To Linked Grp Sets
 
     DAPath            S             10A   DIM(10) INZ(*BLANKS)
      ** Array of group sets/RDE to form a path
 
     DABGnPath         S             70A   DIM(999) ASCEND
      ** Array to store the paths generated without \ characters
 
     DABPosi           S              1A   DIM(70) INZ(*BLANKS)
      ** Array to store the position to path
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     DPReturnCode      S             10A
     DPReturnOut       S             10A
     DPGrpSet          S              6A
     DPGrpSetDes       S             30A
     DPSelect          S              1A
     DPPath            S             70A
     DPElemName        S             30A
     DPFuncKey         S              2A
     DPRtcd            S              7A
     DPOptn            S              7A
     DPMsgID           S              7A
     DPMsgFile         S             10
     D PMsgData        S            244
     D PText1          S            132
     D PText2          S            512
     D PRtnCode        S              7
     DPMsgFLib         S             10
     DPMsgDt           S            256
     DPMsgr            S              5
     DPPrgm            S             10
     DPMsgQ            S             10
     DPMsgType         S              7
     DWPath            S             70A   INZ(*BLANKS)
     DWFrmGrp          S              6A   INZ(*BLANKS)
     DWToGrp           S              6A   INZ(*BLANKS)
     DWError           S              1A   INZ(*BLANKS)
     DWCall33          S              1A   INZ(*BLANKS)
     DWExit            S              1A
     DWPosi            S             70A   INZ(*BLANKS)
     DWSave            S             60A   INZ(*BLANKS)
     DWTotRec          S              3S 0 INZ(0)
     DWIdx             S              3S 0 INZ(0)
     DWSflCtr          S              1S 0
     DWPthIdx          S              2S 0 INZ(1)
     DWGrpIdx          S              2S 0 INZ(0)
     DWz               S              2S 0 INZ(0)
     DWrkRrn           S              4S 0 INZ(0)
     DWrrn             S              4S 0 INZ(0)
     DWRun             S              1
     DWBPath           S             70A   INZ(*BLANKS)
     DWBPosi           S             70A   INZ(*BLANKS)
     DWBId             S              3S 0 INZ(0)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRINIT
 
     C     PGrpSet       CHAIN     @GSASL1                            11
 
     C                   IF        GALGST = 'SYSTEM'                                          211237
     C     PGrpSet       READE     @GSASL1                                11                  211237
     C                   ENDIF                                                                211237
 
      ** Generate paths for top group set if it exists in CGGSASPD
 
     C**********         IF        *IN11 = '0' AND GALGST <> 'SYSTEM'                         211237
     C                   IF        *IN11 = '0'                                                211237
     C                   EVAL      APath(WPthIdx) = PGrpSet
     C                   EXSR      SRWRITE
     C                   EVAL      WFrmGrp = PGrpSet
 
     C                   DOW       *IN11 = '0'
 
      ** Check if To Linked Grp Set is complex
 
     C                   EXSR      SRCMPLX
 
     C     WFrmGrp       READE     @GSASL1                                11
 
      ** If READE results in EOF, verify if there are still grp sets
      ** in array. If so, start back-track processing.
 
     C                   DOW       *IN11 = '1' AND AFrmGrp(1) <> *BLANKS
 
     C                   EVAL      WFrmGrp = AFrmGrp(WGrpIdx)
     C                   EVAL      WToGrp = AToGrp(WGrpIdx)
     C                   EVAL      AFrmGrp(WGrpIdx) = *BLANKS
     C                   EVAL      AToGrp(WGrpIdx) = *BLANKS
     C                   SUB       1             WGrpIdx
     C                   EVAL      APath(WPthIdx) = *BLANKS
     C                   SUB       1             WPthIdx
 
      ** Position file cursor to the record with the complex grp set
      ** then continue processing with the succeeding records.
 
     C     KGSAS         CHAIN     @GSASL1
     C     WFrmGrp       READE     @GSASL1                                11
     C                   ENDDO
 
     C                   ENDDO
 
      ** Clear subfile
 
     C                   EVAL      *IN02 = '1'
     C                   WRITE     CG3619C0
     C                   EVAL      *IN02 = '0'
 
      ** After all paths are generated and written to AGenPath,
      ** build subfile (via AGenPath) one page at a time.
 
     C                   EXSR      SRBUILD
 
      ** If Group Set Definition passed by CG3618 is not found
      ** in PF/CGGSASPD, send message 'No Details To Display'.
 
     C                   ELSE
     C                   EVAL      *IN01 = '0'
     C                   EVAL      *IN08 = '1'
     C                   EVAL      *IN10 = '1'
     C                   EVAL      PMsgID = 'CGD2580'
     C                   EXSR      SRERROR
     C                   ENDIF
 
      ** Display screen
 
     C                   DOW       PFuncKey <> '03' AND *INKL = '0' AND
     C                             WExit = 'N'
 
     C                   WRITE     CG3619F0
     C                   WRITE     CG3619F1
     C                   WRITE     CG3619C1
     C                   EXFMT     CG3619C0
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN01 = '1'
     C                   MOVEA     '00'          *IN(04)
     C                   EVAL      *IN08 = '0'
 
     C                   SELECT
 
      ** F3 pressed
 
     C                   WHEN      *INKC = '1'
     C                   EVAL      PFuncKey = '03'
 
      ** F5 pressed
 
     C                   WHEN      *INKE = '1'
     C                   EVAL      WIdx = 0
     C                   EVAL      #0POSI = *BLANKS
     C                   EVAL      WSave = *BLANKS
     C                   EXSR      SRRFRSH
 
      ** F12 pressed
 
     C                   WHEN      *INKL = '1'
     C                   EVAL      PFuncKey = '12'
 
      ** Rollup
 
     C                   WHEN      *IN09 = '1'
     C                   EXSR      SRBUILD
 
      ** No details processed
 
     C                   WHEN      *IN10 = '1'
     C                   EVAL      *IN01 = '0'                                                211237
     C                   EVAL      *IN08 = '1'                                                211237
     C                   EVAL      PMsgID = 'CGD2580'                                         211237
     C                   EXSR      SRERROR                                                    211237
     C                   ITER
 
     C                   OTHER
 
     C                   IF        #0POSI <> *BLANKS AND #0POSI <> WSave
     C                   EXSR      SRRVIEW
     C                   ELSE
     C                   EXSR      SRVALD
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   EVAL      *INLR = '1'
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCMPLX - Handles complex paths                              *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRWRITE, SRRASC                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCMPLX       BEGSR
 
      ** Bypass processing of paths containing grp set 'SYSTEM'.
 
     C                   IF        GALGST <> 'SYSTEM'
 
      ** Add group set name to paths array and write to subfile.
 
     C                   ADD       1             WPthIdx
     C                   EVAL      APath(WPthIdx) = GALGST
     C                   EXSR      SRWRITE
 
      ** Access Group Set Definitions File CGGSETPD
 
     C     GALGST        CHAIN     @GSETL1
 
      ** If group set is complex, save in array the present
      ** From/To Group Set combination to enable back-tracking later.
 
     C                   IF        GSCSET = 'Y'
     C                   ADD       1             WGrpIdx
     C                   EVAL      AFrmGrp(WGrpIdx) = WFrmGrp
     C                   EVAL      AToGrp(WGrpIdx) = GALGST
 
      ** Position file cursor to first record of complex grp set.
 
     C                   EVAL      WFrmGrp = GALGST
     C     WFrmGrp       SETLL     @GSASL1
 
      ** If group set is not complex, process its RDEs
 
     C                   ELSE
     C                   EXSR      SRRASC
     C                   EVAL      APath(WPthIdx) = *BLANKS
     C                   SUB       1             WPthIdx
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRASC - Get RDEs via RDEs associations file CGRASCPD        *
      *                                                               *
      *  Called by: SRRASC                                            *
      *                                                               *
      *  Calls    : SRWRITE                                           *
      *                                                               *
      *****************************************************************
 
     C     SRRASC        BEGSR
 
     C     GALGST        CHAIN     @RASCL1                            12
 
      ** Get all RDEs for corresponding group set
 
     C                   DOW       *IN12 = '0'
     C                   ADD       1             WPthIdx
     C                   EVAL      APath(WPthIdx) = RARDE
     C                   EXSR      SRWRITE
     C                   EVAL      APath(WPthIdx) = *BLANKS
     C                   SUB       1             WPthIdx
 
     C     GALGST        READE     @RASCL1                                12
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWRITE - Writes generated path to array AGenPath            *
      *                                                               *
      *  Called by: Main, SRCMPLX, SRRASC                             *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRWRITE       BEGSR
 
     C                   EVAL      WPath = *BLANKS
     C                   EVAL      WBPath = *BLANKS
     C                   Z-ADD     1             Wz
 
      ** Concatenate all elements from the paths array.
 
     C                   DOW       APath(Wz) <> *BLANKS
     C                   CAT       '\':0         WPath
     C                   CAT       APath(Wz):0   WPath
     C                   CAT       APath(Wz):1   WBPath
     C                   ADD       1             Wz
     C                   ENDDO
 
     C                   ADD       1             WTotRec
     C                   EVAL      AGenPath(WTotRec) = WPath
     C                   EVAL      ABGnPath(WTotRec) = WBPath
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBUILD - Build subfile one page at a time                   *
      *                                                               *
      *  Called by: Main, SRRFRSH                                     *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRBUILD       BEGSR
 
     C                   EVAL      Wrrn = WrkRrn
     C                   EVAL      WSflCtr = 0
     C                   MOVEA     '00'          *IN(07)
 
      ** Fill subfile until one page is full or until all records from
      ** AGenPath are written to the subfile.
 
     C                   DOU       WIdx = WTotRec OR WSflCtr = 5
 
     C                   ADD       1             WSflCtr
     C                   ADD       1             Wrrn
     C                   ADD       1             WIdx
 
      ** If all records have been written, disable Rollup.
 
     C                   IF        WIdx = WTotRec
     C                   MOVEA     '11'          *IN(07)
     C                   ENDIF
 
     C                   EVAL      CGTYPE = 'PATH'
     C                   EVAL      CGARGT = AGenPath(WIdx)
 
      ** If Path doesn't exist in CGRDECPD, set Element Name to '*UNDEFINED'
 
     C     KRDEC         CHAIN     CGRDECD0                           12
 
     C                   IF        *IN12 = '1'
     C                   EVAL      #0NAME = PText1
     C                   ELSE
     C                   EVAL      #0NAME = CGNWFD
     C                   ENDIF
 
      ** Write to subfile
 
     C                   EVAL      WrkRrn = Wrrn
     C                   EVAL      #0RRN = Wrrn
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      #0PATH = AGenPath(WIdx)
     C                   WRITE     CG3619S0
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALD - Validate Selection Option entered                   *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRERROR, CG3620                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVALD        BEGSR
 
     C                   EVAL      WError = 'N'
     C                   EVAL      WCall33 = 'N'
 
     C                   READC     CG3619S0                               11
 
      ** Validate selection field while not EOF
 
     C                   DOW       *IN11 = '0'
 
      ** Selection field must be 'A', 'E', or blanks.
 
     C                   IF        #0SELE <> 'A' AND #0SELE <> 'E'
     C                             AND #0SELE <> *BLANKS
     C                   IF        WError = 'N'
     C                   EVAL      #0RRN = Wrrn
     C                   ENDIF
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN05 = '1'
     C                   ENDIF
 
      ** If selection field is 'A' or 'E', prepare call to module CG3620.
 
     C                   IF        #0SELE = 'A' OR #0SELE = 'E'
     C                   EVAL      WCall33 = 'Y'
     C                   ENDIF
 
      ** Update subfile record with indicator for SFLNXTCHG set to on.
 
     C                   EVAL      *IN03 = '1'
     C                   UPDATE    CG3619S0
     C                   EVAL      *IN03 = '0'
     C                   EVAL      *IN05 = '0'
 
     C                   READC     CG3619S0                               11
 
     C                   ENDDO
 
     C                   SELECT
 
      ** Send error message 'Selection Option must be A, E or blank'.
 
     C                   WHEN      WError = 'Y'
     C                   EVAL      PMsgID = 'CGD2562'
     C                   EXSR      SRERROR
 
      ** Call CG3620 while there are valid selected records,
      ** and until F3 or F12 is returned.
 
     C                   WHEN      WCall33 = 'Y'
     C                   EVAL      *IN11 = '0'
     C                   EVAL      PFuncKey = *BLANKS
 
     C                   DOW       *IN11 = '0' AND PFuncKey = *BLANKS
     C                   READC     CG3619S0                               11
 
     C                   IF        *IN11 = '0' AND (#0SELE = 'A'
     C                             OR #0SELE = 'E')
     C                   CALLB     'CG3620'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM                    PGrpSet
     C                   PARM                    PGrpSetDes
     C                   PARM      #0SELE        PSelect
     C                   PARM      #0PATH        PPath
     C     #0NAME        PARM      #0NAME        PElemName
     C                   PARM      *BLANKS       PFuncKey
 
     C                   IF        PFunckey = '12'
     C                   EVAL      WExit = 'N'
     C                   ENDIF
 
     C                   IF        #0NAME = *BLANKS
     C                   EVAL      #0NAME = PText1
     C                   ENDIF
 
     C                   EVAL      #0RRN = Wrrn
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      *IN03 = '1'
     C                   UPDATE    CG3619S0
     C                   EVAL      *IN03 = '0'
     C                   ENDIF
 
     C                   ENDDO
 
      ** If user just pressed Enter without positioning/selecting
      ** any record, display 1st page of subfile.
 
     C                   OTHER
     C                   EVAL      WExit = 'Y'
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRVIEW - Position subfile on path entered                   *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRERROR, SRRFRSH                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRVIEW       BEGSR
 
      ** First character of Position field must be '\'
 
     C                   IF        %SUBST(#0POSI:1:1) <> '\'
     C                   EVAL      *IN01 = '0'
     C                   EVAL      *IN04 = '1'
     C                   EVAL      *IN08 = '1'
     C                   EVAL      WSave = *BLANKS
     C                   EVAL      PMsgID = 'CGD2580'
     C                   EXSR      SRERROR
 
     C                   ELSE
 
     C                   EVAL      WSave = #0POSI
     C                   EVAL      WPosi = #0POSI
     C                   EVAL      WIdx  = 1
 
     C                   MOVEA     *BLANKS       ABPosi
     C                   MOVEA     WPosi         ABPosi
     C                   EVAL      WBId = 0
     C                   DOU       WBId = 70
 
      ** Replace '\' with ' ' in the lookup path (except the first)
      ** This is done in order to not disrupt the path sorting as
      ** hexadecimal value of '\' is between a range of letters 'R' and
      ** 'S'.
     C                   ADD       1             WBId
     C                   IF        ABPosi(WBId) = '\'
     C                   EVAL      ABPosi(WBId) = ' '
     C                   ENDIF
     C                   ENDDO
 
     C                   MOVEA     ABPosi        WBPosi
 
      ** Search for the path in the Generated Paths array AGenPath
 
     C     WBPosi        LOOKUP    ABGnPath(WIdx)                     13  14
 
      ** If no record is read, send error message 'No Details To Display'.
 
     C                   IF        *IN13 = '0' AND *IN14 = '0'
     C                   EVAL      *IN01 = '0'
     C                   EVAL      *IN04 = '1'
     C                   EVAL      *IN08 = '1'
     C                   EVAL      PMsgID = 'CGD2580'
     C                   EVAL      WSave = *BLANKS
     C                   EXSR      SRERROR
 
      ** Else, build subfile starting from record retrieved.
 
     C                   ELSE
 
     C                   SUB       1             WIdx
     C                   EXSR      SRRFRSH
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRFRSH - Refresh subfile                                    *
      *                                                               *
      *  Called by: Main, SRRVIEW                                     *
      *                                                               *
      *  Calls    : SRBUILD                                           *
      *                                                               *
      *****************************************************************
 
     C     SRRFRSH       BEGSR
 
      ** Clear subfile
 
     C                   EVAL      *IN02 = '1'
     C                   WRITE     CG3619C0
     C                   EVAL      *IN02 = '0'
 
     C                   EVAL      Wrrn = 0
     C                   EVAL      WrkRrn = 0
     C                   EXSR      SRBUILD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERROR - Handles error messages                             *
      *                                                               *
      *  Called by: SRVALD, SRRVIEW                                   *
      *                                                               *
      *  Calls    : AOCREPT                                           *
      *                                                               *
      *****************************************************************
 
     C     SRERROR       BEGSR
 
     C                   CALL      'AOCREPT'
     C                   PARM                    PMsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgFLib
     C                   PARM      *BLANKS       PMsgDt
     C                   PARM      *BLANKS       PMsgr
     C                   PARM      *BLANKS       PPrgm
     C                   PARM      *BLANKS       PMsgQ
     C                   PARM      *BLANKS       PMsgType
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation                                      *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : ZA0250                                            *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Initialise fields and indicators
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #1PGM = PSProcName
     C                   EVAL      PMsgFile = 'CGUSRMSG'
 
      ** Extract message '*UNDEFINED' via CLP CGC0100.
 
     C                   CALL      'CGC0100'
     C                   PARM      'CGD2583'     PMsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgData
     C                   PARM      *BLANKS       PText1
     C                   PARM      *BLANKS       PText2
     C                   PARM      *BLANKS       PRtnCode
 
      ** Database error if message id does not exist.
 
     C                   IF        PRtnCode = '*NRF   '
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = PMsgFile
     C                   EVAL      DBKEY = PMsgID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #0RRN = 1
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      #0PATH = *BLANKS
     C                   EVAL      #0NAME = *BLANKS
     C                   EVAL      #0POSI = *BLANKS
     C                   EVAL      #0DEFN = PGrpSet
     C                   EVAL      #0DESC = PGrpSetDes
     C                   EVAL      *IN01 = '1'
     C                   EVAL      WExit = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0                                          *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PReturnOut
     C                   PARM                    PGrpSet
     C                   PARM                    PGrpSetDes
     C                   PARM                    PFuncKey
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     KRDEC         KLIST
     C                   KFLD                    CGTYPE
     C                   KFLD                    CGARGT
 
     C     KGSAS         KLIST
     C                   KFLD                    WFrmGrp
     C                   KFLD                    WToGrp
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR  - Program exception error routine                         *
      *           Called automatically if a program error occurs,         *
      *           or directly by the program code using EXSR.             *
      *           This subroutine DUMPs the program just once.            *
      *                                                                   *
      *  Called by: *INZSR                                                *
      *                                                                   *
      *  Calls    : DBERRCTL                                              *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
