     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility database update controller')         *
      *****************************************************************
      *                                                               *
      *  Midas - LE Customer Lending                                  *
      *                                                               *
      *  LEFCIPUPC - FACILITY DATABASE UPDATE CONTROLLER              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CLE168             Date 26Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 AR937578A          Date 04Apr12               *
      *                 CLE147             Date 30Sep11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245219             Date 09Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9095            Date 21Jul05               *
      *                 CER001             Date 25Apr05               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 201589             Date 03Jan02               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CLE168 - Allow Debit of Blocked Account (Recompile)          *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Core hooks added:LEFCIPUC01,LEFCIPUC02,LEFCIPUC05   *
      *  AR937578A - In Collateral and Credit Lines Enquiry, availed  *
      *              loans are both in reservation and exposure       *
      *              columns                                          *
      *  CLE147 - Aggregate Facility (Recompile)                      *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245219 - Missing facilities in extension file LEFCLTQD       *
      *           (Usually input through java layer)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9095 - No deletetion of record for LEVFCIMPD and          *
      *            LEVFCINPD                                          *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompiled)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************
     FLEVFCIMPD UF   E             DISK
     F                                     COMMIT
     FLEVFCINPD UF   E             DISK
     F                                     COMMIT
     FLEVFCIML1 UF   E           K DISK
     F                                     RENAME(LEVFCIMD0:LEVFCIMD1)
     FLEVFCINL1 UF   E           K DISK
     F                                     RENAME(LEVFCIND0:LEVFCIND1)
     FLEVEFCIMPDO    E             DISK
     F                                     RENAME(LEVFCIMD0:LEVFCIMERR)
     FLEVEFCINPDO    E             DISK
     F                                     RENAME(LEVFCIND0:LEVFCINERR)
      **  Facilities Details file
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(FCLTYFMF)

     FLEVFCLX1L0UF A E           K DISK                                                       CER001
     F                                     COMMIT                                             CER001
     F                                     RENAME(LEVFCIPX6:VFCIPY6)                          CER001
      *                                                                                       CER001
      ** LE Facility LUX Valid File                                                           CER001
      *                                                                                       CER001
     FLEVEFCX1PDUF A E           K DISK                                                       CER001
     F                                     RENAME(LEVFCIPX6:VEFCIPD6)                         CER001
      *                                                                                       CER001
      ** LE Facility LUX Valid Error File                                                     CER001
      *                                                                                       CER001
      ** Midas Facilities Extension Details.                                                  245219
     FLEFCLTLH  UF A E           K DISK    INFSR(*PSSR)                                       245219
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LEFCIPU010

     FLEVFCIPY0 UF   E           K DISK                                                      LLN022A
     F                                     RENAME(LEVFCIX0:VFCIPD0)                          LLN022A
     FLEVEFCIPX0UF A E             DISK                                                      LLN022A
     F                                     RENAME(LEVFCIX0:VEFCIPD0)                         LLN022A
                                                                                             LLN022A
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **------------------------------------------------------------------------

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in FCIP API update')

      *****************************************************************

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID FACILITY
     D LEVFCIM       E DS                  EXTNAME(LEVFCIMPD)
     D LEVFCIN       E DS                  EXTNAME(LEVFCINPD)

     D LEFCIPUPC       DS             1    DTAARA(LEFCIPUPC)

     D FCIP_OK       E DS                  EXTNAME(LEEFCIPPD)
      ** Assignment Details OK indicator

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structure for SAR details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
                                                                                              CER001
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
      ** External DS for module details                                                       CER001

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short date structure

     D NwFCIPFilFmt  E DS                  EXTNAME(LEVFCLX1L0)                                CER001
      *                                                                                       CER001
      ** Facility LUX Valids extension file                                                   CER001
      *                                                                                       CER001
     D Object          S             10A   INZ('LEFCIPUPC')
     D LockObj         S             10A   INZ('LEFCIPLCK')                                   201589
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A                                                      201589
     D Endjob          S              1A   INZ('Y')                                           201589
     D @Timestamp      S             26Z

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
     D ULX004          S              1A                                                      CER001

      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+

      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEFCIPU011
                                                                                             LLN022A
     D ValidFCIPEx   E DS                  EXTNAME(LEVFCIPX0)                                LLN022A
     D                                     Prefix(N)                                         LLN022A

      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************

      /COPY WNCPYSRC,LEFCIPU001

      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APFCIPDTQ'

      **-----------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **-----------------------------------------------------------------------

      *  Initialise Data queue parms
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APFCIPDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
     C     DtqDta        DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM                    DtqWait           5 0
     C     DtqDta        IFEQ      'GO'
      *  Lock allocation data area
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return

      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
     C                   CLEAR                   *inu7
     C                   CLEAR                   *inu8

      /COPY WNCPYSRC,LEFCIPU002

      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     LEVFCIMPD
     C     1             SETLL     LEVFCINPD

      ** READ VALID FACILITY FM AND FN
     C                   READ      LEVFCIMD0                              99    *
     C                   READ      LEVFCIND0                              99    *
     C                   DOW       *IN99 = *OFF

      /COPY WNCPYSRC,LEFCIPU003

      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lowere level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = FPPCRF

      /COPY WNCPYSRC,LEFCIPU004

      ** Retrieve the transaction number of last update from FCLTYFM

     C                   MOVE      FPCNUM        K#CNUM
     C                   MOVE      FPFACT        K#FACT
     C                   MOVE      FPFCNO        K#FCNO
     C                   MOVE      'A'           K#RCTP

     C     FCLTYK        CHAIN     FCLTY                              80

      ** LE DATABASE UPDATE
     C                   CALLB     'LEFCIPUPD'
     C                   PARM      *BLANKS       @@RTCD            7
      * Mode
     C                   PARM      'B'           P#MODE            1
     C                   PARM                    LEVFCIM
     C                   PARM                    LEVFCIN
     C                   PARM                    CLE008
     C                   PARM                    CSC011
      * Local currency
     C                   PARM                    BJLCCY
      *                                                                                    AR937578A
     C                   PARM                    BJSLCD            3                       AR937578A
      * Run date
     C                   PARM                    BJRDNB
      * TNLU of funding participant record on FCLTYFM/FN
     C                   PARM      TNLU          H#TNLU            5 0
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FCIP_OK
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

      /COPY WNCPYSRC,LEFCIPU007

      ** If LLN007 is on update BOE extension file.                                          LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C     FPFRNT        CHAIN     LEVFCIPY0                                                 LLN022A
                                                                                             LLN022A
     C                   IF        NOT %FOUND(LEVFCIPY0)                                     LLN022A
     C                   MOVEL     'LEVFCIPY0'   DBFILE            8                         LLN022A
     C                   MOVEL     '001'         DBASE             3 0                       LLN022A
     C                   MOVEL     FPFRNT        DBKEY            29                         LLN022A
     C                   EXSR      *PSSR                                                     LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   IF        FPCHTP <> *BLANKS                                         LLN022A
     C                   EVAL      ACTN = FPCHTP                                             LLN022A
     C                   ELSE                                                                LLN022A
     C                   EVAL      ACTN = FNCHTP                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   CALLB     'LEFCIPUPD1'                                              LLN022A
     C                   PARM                    PRTCD            10                         LLN022A
     C                   PARM                    ACTN              1                         LLN022A
     C                   PARM                    ValidFCIPEx                                 LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** If ULX004 is installed, do the following                                             CER001
      ** Check valid extensino file                                                           CER001
      ** Execute LUX update extension file                                                    CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   IF        @@RTCD  = *BLANKS                                          CER001
     C     @KeyFcipExt   CHAIN     LEVFCLX1L0                                                 CER001
     C                   IF        NOT %FOUND(LEVFCLX1L0)                                     CER001
     C                   MOVEL     'LEVFCLX1L0'  DBFILE            8                          CER001
     C                   MOVEL     '001'         DBASE             3 0                        CER001
     C                   MOVEL     ARFOTranId    DBKEY            29                          CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   CALLB     'LEFCIP2UP'                                                CER001
     C                   PARM      *BLANK        @@RTCD                                       CER001
     C                   PARM      FPCHTP        ACTN              1                          CER001
     C                   PARM                    NwFCIPFilFmt                                 CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   ROLBK
     C                   ELSE
                                                                                              245219
      ** Add record to LEFCLTQD once facility is on FCLTYFM                                   245219
     C                   IF        FPCHTP = 'I'                                               245219
     C                   EXSR      WriteFCLTQD                                                245219
     C                   END                                                                  245219
                                                                                              245219
     C                   DELETE    LEVFCIMD0                                                 BUG9095
     C                   DELETE    LEVFCIND0                                                 BUG9095
      *                                                                                      LLN022A
      ** If LLN007 is installed, delete valid file record                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C     FPFRNT        CHAIN     LEVFCIPY0                                                 LLN022A
     C                   IF        %FOUND(LEVFCIPY0)                                         LLN022A
     C                   DELETE    VFCIPD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** If ULX004 is installed, delete valid file record                                     CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y'                                              CER001
     C     @KeyFcipExt   CHAIN     LEVFCLX1L0                                                 CER001
     C                   IF        %FOUND(LEVFCLX1L0)                                         CER001
     C                   DELETE    VFCIPY6                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   COMMIT
     C                   END

      /COPY WNCPYSRC,LEFCIPU008

     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'

      * Check for Facility on valid file
     C     @KEYFCIP      CHAIN     LEVFCIML1                          89
     C     @KEYFCIP      CHAIN     LEVFCINL1                          89
     ** Write details of record to error file (same format as LEVFCIMPD)
     C                   WRITE     LEVFCIMERR
     C                   WRITE     LEVFCINERR
     C                   DELETE    LEVFCIMD1
     C                   DELETE    LEVFCIND1
      *                                                                                       CER001
      ** If ULX004 is installed, do the following:                                            CER001
      ** Create a record in valid error file                                                  CER001
      ** Delete valid file record                                                             CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y'                                              CER001
     C     @KeyFcipExt   CHAIN     LEVFCLX1L0                         89                      CER001
     C                   IF        %FOUND(LEVFCLX1L0)                                         CER001
     C                   WRITE     VEFCIPD6                                                   CER001
     C                   DELETE    VFCIPY6                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
      ** If LLN007 is installed, do the following:                                           LLN022A
      ** Create a record in valid error file                                                 LLN022A
      ** Delete valid file record                                                            LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C     FPFRNT        CHAIN     LEVFCIPY0                          89                     LLN022A
     C     *IN89         IFEQ      *OFF                                                      LLN022A
     C                   WRITE     VEFCIPD0                                                  LLN022A
     C                   DELETE    VFCIPD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF

     C                   ENDIF

      ** READ VALID FCLTY
     C                   READ      LEVFCIMD0                              99    *
     C                   READ      LEVFCIND0                              99    *
     C                   END
     ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
     C                   END
      ** End loop for data queue prompt
     C                   END

      /COPY WNCPYSRC,LEFCIPU009

      * EXIT FROM PROGRAM
     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LEFCIPU012

      *****************************************************************
      /EJECT                                                                                  245219
      *****************************************************************                       245219
      *                                                               *                       245219
      * WriteFCLTQD - WRITE Facility record to extension file         *                       245219
      *               (Usually done from Java layer)                  *                       245219
      *                                                               *                       245219
      *****************************************************************                       245219
     C     WriteFCLTQD   BEGSR                                                                245219
      *                                                                                       245219
      ** When opening facilities within FCLTYFM write a corresponding                         245219
      ** record in the facilities extension file LEFCLTQD.                                    245219
      *                                                                                       245219
     C     @KeyFCIPH     KLIST                                                                245219
     C                   KFLD                    FCXFCU                                       245219
     C                   KFLD                    FCXFTP                                       245219
     C                   KFLD                    FCXFNO                                       245219
      *                                                                                       245219
     C                   MOVE      FPCNUM        FCXFCU                                       245219
     C                   MOVE      FPFACT        FCXFTP                                       245219
     C                   MOVE      FPFCNO        FCXFNO                                       245219
      *                                                                                       245219
     C     @KeyFCIPH     CHAIN     LEFCLTD0                           82                      245219
      *                                                                                       245219
     C     *IN82         IFEQ      *ON                                                        245219
     C                   EVAL      FCXBRC = FPBRCA                                            245219
     C                   WRITE     LEFCLTD0                                                   245219
     C                   ENDIF                                                                245219
                                                                                              245219
     C                   ENDSR                                                                245219
      *****************************************************************                       245219
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR


     C     *LIKE         DEFINE    FPCNUM        K#CNUM
     C     *LIKE         DEFINE    FPFACT        K#FACT
     C     *LIKE         DEFINE    FPFCNO        K#FCNO
     C     *LIKE         DEFINE    RCTP          K#RCTP

      *  Define key list for LEVFCINL1
     C     @KeyFcip      KLIST
     C                   KFLD                    FPCNUM
     C                   KFLD                    FPFACT
     C                   KFLD                    FPFCNO

      *  Define key list for FCLTY
     C     FCLTYK        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#RCTP
      *                                                                                       CER001
      ** Define key list for LEVFCLX1L0                                                       CER001
      *                                                                                       CER001
     C     @KeyFcipExt   KLIST                                                                CER001
     C                   KFLD                    FPSTMP                                       CER001
     C                   KFLD                    FPFRNT                                       CER001
      *  Check if an existing DBU_CLIP job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    LockObj                                      201589
     C                   PARM                    Lib                                          201589
     C                   PARM                    ObjType                                      201589
     C                   PARM                    LockStateE                                   201589
     C                   PARM                    Member                                       201589
     C                   PARM                    Endjob                                       201589
     C                   PARM                    Return2                                      201589
                                                                                              201589
      *  Lock allocation data area

      *   The data area is allocated *SHRRD here and *EXCL whilst processing
      *    of the valid file is actually taking place.
      *   The function to submit this updater tries to get a *EXCL lock.
      *   The controller tries to get a *SHRRD lock.

      *                         Submitter             Controller
      *                 Lock      Lock     Submitter     Lock     Controller
      *      Status    Status   Successful   Action   Successful    Action
      *      ------    ------   ---------- ---------  ----------  ----------
      *   Not running  None        Yes      Submit       Yes        Prompt
      *                                     updater                 updater

      *   Running not  *SHRRD      No        None        Yes        Prompt
      *    processing                                               updater

      *   Processing   *EXCL       No        None        No         None

     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return

      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEFCIPU013

      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CER001
     C                   CALLB     'AOMMODR0'                                                 CER001
     C                   PARM      '*DBERR '     @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001

      ** Determine if CLE008 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE008            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE008
     C                   ENDIF

      ** Determine if CSC011 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CSC011            1
     C                   ELSE
     C                   MOVEL     'Y'           CSC011
     C                   ENDIF
      *                                                                                      LLN022A
      ** Access SAR details file to determine if LLN007                                      LLN022A
      ** Bank of England Yellow Book Changes is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN007            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN007 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN007 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** Determine if ULX004 is installed                                                     CER001
      *                                                                                       CER001
     C                   EVAL      ULX004  = 'N'                                              CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
                                                                                              CER001
     C                   IF        @RTCD   = *Blanks                                          CER001
     C                   EVAL      ULX004  = 'Y'                                              CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX004 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   IF        @RTCD  <> '*NRF'                                           CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBPGM   = 'LEFCIPUPC'                                      CER001
     C                   EVAL      DBFILE  = 'SCSARDPD'                                       CER001
     C                   EVAL      DBKEY   = 'ULX004'                                         CER001
     C                   EVAL      DBASE   = 002                                              CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001

     C                   EVAL      @RTCD = *BLANKS

     C                   ENDSR
      ****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
