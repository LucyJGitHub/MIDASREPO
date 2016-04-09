     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Recipient Codes Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0373 - Recipient Codes Maintenance                         *
      *                                                               *
      *  Function:  This program maintains the Recipient Code Details *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 BUG3644            Date 12Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023   *CREATE   Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    09         F9 Add/Change Mode                              *
      *    27         Rollup/Rolldown Key                             *
      *    31         Maintenance/Enquiry Mode                        *
      *    32         Invalid Selection                               *
      *    33         Invalid Country of Treaty                       *
      *    34         Invalid Recipient Code                          *
      *    35         Invalid Narrative                               *
      *    40         Global Error Indicator                          *
      *    60         READ/CHAIN Indicator                            *
      *    61         READ Indicator                                  *
      *    62         READC Indicator                                 *
      *    78         Protect Country of Treaty and Recipient Code    *
      *    79         Protect Selection Field                         *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Subfile End (SFLEND)                            *
      *    83         Force Input Format                              *
      *    84         Subfile Next Change (SFLNXTCHG)                 *
      *    86         PUTOVR Indicator                                *
      *    87         Enable Key Screen                               *
      *    89         Add Mode                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRBuild       -  Initialise and load subfile page            *
      *  SRLoad        -  Load subfile page                           *
      *  SRDisplay     -  Display subfile                             *
      *  SRProcess     -  Process screen input                        *
      *  SRSubfileRec  -  Process modified subfile record             *
      *  SRAction      -  Process subfile record                      *
      *  SRNullRecord  -  Check for null record                       *
      *  SRValidKey    -  Validate subfile record                     *
      *  SRValidate    -  Validate subfile record relations           *
      *  SRUpdate      -  Update records from subfile                 *
      *  SRDetail      -  Process action requested                    *
      *  SRAddReq      -  Process add request                         *
      *  SRDelReq      -  Process delete request                      *
      *  SRUpdReq      -  Process update request                      *
      *  SRTrailer     -  Update Control Files                        *
      *  SRMode        -  Switch between *ADD and *CHANGE modes       *
      *  SRReload      -  Request subfile reload                      *
      *  SRProtect     -  Set display attributes for subfile record   *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Transfer records from SDRPCDL1 to subfile   *
      *  SRWrite       -  Create Recipient Codes                      *
      *  SRDelete      -  Delete Recipient Codes                      *
      *  SRAmend       -  Update Recipient Codes                      *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      /EJECT
     FSD0373DF  CF   E             WORKSTN USROPN
     F                                     SFILE(SD0373F0:SRLRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      *
     FSDRPCDL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(RPCDL0)
     F                                     COMMIT
     F                                     RENAME(SDRPCDD0:@RPCDL0)
      ** Recipient Codes - Update
      *
     FSDRPCDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(RPCDL1)
     F                                     RENAME(SDRPCDD0:@RPCDL1)
      ** Recipient Codes - Retrieve
      *
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Control File Update Index
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /EJECT
      *
      ** Review from fields
      *
     D                 DS
     D  SPOSN                  1      4
     D  SPOS1                  1      2
     D  SPOS2                  3      4
      *
      ** File Information
      *
     D RPCDL0          DS
     D  #RPCD0                 9      9
     D RPCDL1          DS
     D  #RPCD1                 9      9
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structure for Bank Details
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** External data structure for Country Codes
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
      *
     D @1DBRC        E DS                  EXTNAME(SDRPCDL0)
      ** Current/previous master file format fields for change control
      *
     D YCRDCS          DS            44
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      *
     D @RUN            S              1
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Main Program
      *
     C                   DO        *HIVAL
      *
      ** Initialise and load subfile page
      *
     C                   EXSR      SRBuild
      *
     C                   MOVEL     'N'           W0RSF             1
      *
      ** Display screen until reload requested
      *
     C     W0RSF         DOWEQ     'N'
      *
      ** Display screen
      *
     C                   EXSR      SRDisplay
      *
      ** Process response
      *
     C     *IN03         CASEQ     '1'           SREnd
      *
     C     *IN05         CASEQ     '1'           SRReload
      *
     C     *IN27         CASEQ     '1'           SRLoad
      *
     C                   CAS                     SRProcess
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDDO
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *             *PSSR                                             *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Receive entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMODE             1
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD0373'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 0
     C                   OUT       LDA
      *
      ** Obtain default message file
      *
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      *
      ** Call Access Program for Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
     C                   IF        WRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = WOPTN
     C                   EVAL      DBPGM  = 'SD0373'
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Open files for update
      *
     C                   OPEN      SD0373DF
     C     #RPCD0        IFNE      '1'
     C                   OPEN      SDRPCDL0
     C                   ENDIF
     C     #RPCD1        IFNE      '1'
     C                   OPEN      SDRPCDL1
     C                   ENDIF
      *
     C                   Z-ADD     14            WSFPG             3 0
      *
      ** Set to *CHANGE mode
      *
     C                   MOVEL     'CHG'         W0PMD             3
      *
      ** Initialise subfile control
      *
     C                   MOVEL     *BLANKS       SPOSN
     C                   MOVEL     BJMRDT        SRUNA
      *
     C                   EVAL      SPGM = PSProcName
     C                   EVAL      SWSID = PSJobName
     C                   EVAL      SUSER = PSUser
      *
      ** Initialise Key Lists
      *
     C     KEY1          KLIST
     C                   KFLD                    KCRTT             2
     C                   KFLD                    KRPCD             2
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : SRLoad, SRZasnms                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRBuild       BEGSR
      *
      ** Initialise & load subfile page
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     SD0373F1
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN81
      *
      ** Reset Number of Records in Subfile
      *
     C                   Z-ADD     0             WLRCD             4 0
      *
      ** If CHANGE mode, then position file
      *
     C                   IF        W0PMD <> 'ADD'
     C                   MOVEL     SPOSN         WPOSN             4
     C                   MOVEL     SPOS1         KCRTT
     C                   MOVEL     SPOS2         KRPCD
      *
     C                   MOVEL     SPOS1         RPCRTT
     C                   MOVEL     SPOS2         RPRPCD
      *
      ** Setup key
      *
     C     KEY1          SETLL     @RPCDL1                            82
      *
     C                   READ      @RPCDL1                                82
     C                   ELSE
     C                   MOVE      '0'           *IN82
     C                   ENDIF
      *
      ** Load subfile page
      *
     C                   EXSR      SRLoad
      *
      ** If no records found, display error message
      *
     C                   IF        *IN82 and SRLRN = 0
     C                   MOVEL     'USR7530'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      * Called by: Main routine, SRBuild                              *
      *                                                               *
      * Calls    : SRClrScrn, SRMove, SRValidate, SRProtect           *
      *                                                               *
      *****************************************************************
      *
     C     SRLoad        BEGSR
      *
      ** Load subfile page but write empty page if add mode
      *
     C                   MOVE      '0'           *IN84
      *
      ** Re-establish fields in read-ahead record
      *
     C                   IF        W0PMD <> 'ADD' and *IN27 and *IN82 = '0'
     C                   READP     @RPCDL1                                60
     C                   READ      @RPCDL1                                60
     C                   ENDIF
      *
      ** Start at previous highest record in SFL
      *
     C                   Z-ADD     WLRCD         SRLRN
     C                   Z-ADD     1             WRCTR             5 0
      *
      ** Load next subfile page
      *
     C     *IN82         DOWEQ     '0'
     C     WRCTR         ANDLE     WSFPG
      *
     C                   ADD       1             SRLRN
     C                   MOVEA     '0000'        *IN(32)
     C                   MOVE      '0'           *IN87
      *
      ** Protect fields during Enquiry Mode
      *
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN78 = '1'
     C                   EVAL      *IN79 = '1'
     C                   EVAL      *IN87 = '1'
     C                   ENDIF
      *
      ** Clear subfile fields
      *
     C                   EXSR      SRClrScrn
      *
      ** If CHANGE mode, load subfile fields
      *
     C                   IF        W0PMD <> 'ADD'
     C                   EXSR      SRMove
      *
     C                   MOVEL     RPCRTT        SCRTT
     C                   MOVEL     RPRPCD        SRPCD
      *
      ** Validate subfile record and calculate derived fields
      *
     C                   EXSR      SRValidate
      *
     C                   ENDIF
      *
      ** Output to subfile
      *
     C                   ADD       1             WRCTR                81
     C                   MOVE      '1'           *IN81
      *
      ** If SFLRCD invalid, note that errors present
      *
     C                   IF        *IN83 and *IN40 = '0'
     C                   MOVE      '1'           *IN40
     C                   ENDIF
      *
      ** Set screen conditioning indicators
      *
     C                   EXSR      SRProtect
      *
     C                   WRITE     SD0373F0
      *
      ** End of File
      *
     C     W0PMD         IFNE      'ADD'
     C                   READ      @RPCDL1                                82
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   Z-ADD     SRLRN         WLRCD
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls    : ZA0250                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRDisplay     BEGSR
      *
      ** Set screen conditioning indicators
      *
     C                   IF        W0PMD = 'ADD'
     C                   MOVE      '1'           *IN89
     C                   ELSE
     C                   MOVE      '0'           *IN89
     C                   ENDIF
      *
      ** PUTOVR unless conditioned fields change
      *
     C                   MOVE      '1'           *IN86
     C                   IF        *IN89 <> CAIN89 or *IN81 <> CAIN81
     C                   MOVE      '0'           *IN86
     C                   ENDIF
      *
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
      *
      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance
      *
     C                   IF        PMODE = 'E'
     C                   MOVE      '1'           *IN31
     C                   ENDIF
      *
      ** Set cursor by *SET CURSOR data
      *
     C                   TIME                    STIME
     C                   WRITE     #MSGCTL
     C                   WRITE     SD0373F2
     C                   EXFMT     SD0373F1
      *
      ** Clear messages from program message queue
      *
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process Screen Input                              *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : SRReload, SRSubfileRec, SRUpdate, SRMode           *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
      ** Change of position specified
      *
     C                   IF        W0PMD <> 'ADD' and WPOSN <> SPOSN
     C                   EXSR      SRReload
     C                   ENDIF
      *
      ** Quit if reload requested
      *
     C     W0RSF         IFNE      'Y'
      *
     C     *IN81         IFEQ      '1'
     C                   MOVEL     'N'           WKIPIN            1
      *
      ** Process subfile records
      *
     C                   EXSR      SRSubfileRec
      *
      ** Update DBF from subfile
      *
     C                   IF        *IN40 <> '1' and WKIPIN = 'Y'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Switch between *ADD/*CHANGE modes is allowed when no errors
      ** exists during update
      *
     C                   IF        *IN09  and *IN40 = '0'
     C                   EXSR      SRMode
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSubfileRec - Process Modified Subfile Record                *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRAction, SRProtect                                *
      *                                                               *
      *****************************************************************
      *
     C     SRSubfileRec  BEGSR
      *
      ** Process modified subfile record
      *
     C                   READC     SD0373F0                               62
      *
     C     *IN62         DOWEQ     '0'
     C                   EXSR      SRAction
     C                   MOVE      '0'           *IN87
     C                   EXSR      SRProtect
     C                   UPDATE    SD0373F0
     C                   READC     SD0373F0                               62
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAction - Process Subfile Record                             *
      *                                                               *
      * Called by: SRSubfileRec                                       *
      *                                                               *
      * Calls    : SRNullRecord, SRValidKey                           *
      *                                                               *
      *****************************************************************
      *
     C     SRAction      BEGSR
      *
      ** Set off error indicators
      *
     C                   MOVEA     '0000'        *IN(32)
     C                   MOVEA     '00'          *IN(83)
      *
      ** Check for null record if action is Insert
      *
     C                   IF        W0PMD = 'ADD'
     C                   EXSR      SRNullRecord
     C                   ENDIF
      *
      ** If not null record, continue
      *
     C     W0NLR         IFNE      'Y'
     C                   MOVEL     'Y'           WKIPIN
      *
     C                   MOVE      '1'           *IN84
      *
      ** Validate record
      *
     C                   EXSR      SRValidKey
      *
      ** Seton Global Error Indicator if error exists
      *
     C     *IN83         IFEQ      '1'
     C                   MOVE      '1'           *IN40
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNullRecord - Check for Null Record                          *
      *                                                               *
      * Called by: SRAction, SRDetail                                 *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRNullRecord  BEGSR
      *
     C                   MOVEL     'N'           W0NLR             1
      *
     C     SCRTT         IFEQ      *BLANKS
     C     SRPCD         ANDEQ     *BLANKS
     C     SNARR         ANDEQ     *BLANKS
     C                   MOVEL     'Y'           W0NLR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidKey - Validate Subfile Record                          *
      *                                                               *
      * Called by: SRAction                                           *
      *                                                               *
      * Calls    : SRZasnms, SRValidate                               *
      *                                                               *
      *****************************************************************
      *
     C     SRValidKey    BEGSR
      *
      ** In Add mode, need to move screen value to hidden file field
      *
     C                   IF        W0PMD = 'ADD'
     C                   MOVEL     SCRTT         S#CRTT
     C                   MOVEL     SRPCD         S#RPCD
      *
      ** Country of Treaty is blank
      *
     C                   IF        SCRTT = *BLANKS
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7532'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Recipient Code is blank
      *
     C                   IF        SRPCD = *BLANKS
     C                   MOVE      '1'           *IN34
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7533'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Validate Action
      *
     C                   ELSE
      *
     C                   IF        S1SEL <> 'D' and S1SEL <> *BLANKS
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7531'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate subfile record relations
      *
     C                   EXSR      SRValidate
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Subfile Record Relations                *
      *                                                               *
      * Called by: SRLoad, SRValidKey                                 *
      *                                                               *
      * Calls    : AOCTRYR0 - Access Country Codes                    *
      *            SRZasnms                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRValidate    BEGSR
      *
      ** Validate Country of Treaty
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      '*BLANKS '    WRTCD
     C                   PARM      '*KEY    '    WOPTN
     C                   PARM      SCRTT         WCRTT             2
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        WRTCD <> *BLANKS
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7534'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   MOVE      A4CNCD        SCRTT
     C                   IF        W0PMD = 'ADD'
     C                   MOVE      A4CNCD        S#CRTT
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Recipient Code
      *
     C                   IF        SRPCD = *BLANKS and *IN34 = '0'
     C                   MOVE      '1'           *IN34
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7533'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update Records from Subfile                        *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRDetail, SRProtect                                *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate      BEGSR
      *
      ** Initialise subfile reload flag
      *
     C                   IF        W0PMD = 'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   ENDIF
      *
      ** Process all modified subfile records
      *
     C                   READC     SD0373F0                               62
      *
     C     *IN62         DOWEQ     '0'
     C                   EXSR      SRDetail
      *
      ** Rollback any DBF changes if error occur
      *
     C                   IF        W#EROR <> *BLANKS
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
      *
      ** Set screen conditioning indicators
      *
     C                   MOVEL     *BLANKS       S1SEL
     C                   EXSR      SRProtect
     C                   UPDATE    SD0373F0
     C                   READC     SD0373F0                               62
     C                   ENDDO
      *
      ** Cancel reload if errors occur
      *
     C                   IF        *IN40 = '1'
     C                   MOVEL     'N'           W0RSF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetail - Process action requested                           *
      *                                                               *
      * Called by: SRUpdate                                           *
      *                                                               *
      * Calls    : SRNullRecord, SRAddReq, SRDelReq, SRUpdReq         *
      *                                                               *
      *****************************************************************
      *
     C     SRDetail      BEGSR
      *
      ** Set off error indicators
      *
     C                   MOVEA     '0000'        *IN(32)
     C                   MOVE      '0'           *IN83
      *
      ** Process add request
      *
     C                   IF        W0PMD = 'ADD'
      *
     C                   EXSR      SRNullRecord
     C                   IF        W0NLR <> 'Y'
     C                   EXSR      SRAddReq
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Process delete request
      *
     C                   IF        S1SEL = 'D'
     C                   EXSR      SRDelReq
     C                   ELSE
      *
      ** Process change request
      *
     C                   EXSR      SRUpdReq
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        *IN83 and *IN40 = '0'
     C                   MOVE      '1'           *IN40
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAddReq - Process Add Request                                *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRWrite, SRTrailer                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRAddReq      BEGSR
      *
      ** Create Recipient Code Details
      *
     C                   EXSR      SRWrite
      *
      ** Error detected
      *
     C                   IF        W#EROR <> *BLANKS
     C                   MOVEA     '111'         *IN(33)
     C                   MOVEA     '11'          *IN(83)
     C                   MOVE      '0'           *IN87
     C                   ELSE
     C                   MOVE      '0'           *IN84
     C                   MOVE      '1'           *IN87
     C                   EXSR      SRTrailer
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelReq - Process Delete Request                             *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRDelete, SRMove, SRClrScrn                        *
      *                                                               *
      *****************************************************************
      *
     C     SRDelReq      BEGSR
      *
      ** Delete Recipient Code Details
      *
     C                   EXSR      SRDelete
      *
     C                   IF        W#EROR <> *BLANKS
      *
      ** Delete unsuccessful
      *
     C                   MOVEA     '1111'        *IN(32)
     C                   MOVEA     '11'          *IN(83)
     C                   MOVE      '0'           *IN87
     C                   EXSR      SRMove
     C                   ELSE
      *
      ** Blank out record and protect from entry
      *
     C                   EXSR      SRTrailer
     C                   EXSR      SRClrScrn
     C                   MOVE      '0'           *IN84
     C                   MOVE      '1'           *IN87
      *
      ** Reload subfile
      *
     C                   MOVEL     'Y'           W0RSF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdReq - Process Update Request                             *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRAmend, SRMove, SRTrailer                         *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdReq      BEGSR
      *
      ** Amend Recipient Code Details
      *
     C                   EXSR      SRAmend
      *
     C                   IF        W#EROR <> *BLANKS
     C                   MOVEA     '1111'        *IN(32)
     C                   MOVE      '0'           *IN87
     C                   MOVEA     '11'          *IN(83)
      *
      ** Reset subfile record if changed record
      *
     C                   EXSR      SRMove
     C                   ELSE
      *
      ** Enable entry
      *
     C                   MOVE      '0'           *IN84
     C                   MOVE      '0'           *IN87
     C                   EXSR      SRTrailer
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTrailer - Update Control Files                              *
      *                                                               *
      * Called by: SRAddReq, SRDelReq, SRUpdReq                       *
      *                                                               *
      * Calls    : *PSSR                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRTrailer     BEGSR
      *
     C                   MOVEL     'SDRPCDPD'    WFNAM            10
     C     WFNAM         CHAIN     SDFCTLL0                           60
      *
     C                   IF        *IN60
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBKEY = WFNAM
     C                   EVAL      DBPGM = 'SD0373'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C                   SELECT
     C     W0PMD         WHENEQ    'ADD'
     C                   ADD       1             AHNORC
     C                   ADD       1             AHNOIN
     C     S1SEL         WHENEQ    'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC
     C     YCRDC         WHENEQ    'Y'
     C                   ADD       1             AHNOAM
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   UPDATE    @AHREAU
      *
     C                   COMMIT
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMode - Switch Between *ADD and *CHANGE Modes                *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRReload                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRMode        BEGSR
      *
      ** Switch between *ADD/*CHANGE modes
      *
     C                   IF        W0PMD <> 'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       SPOSN
      *
     C                   EXSR      SRReload
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      * Called by: Main routine, SRProcess, SRMode                    *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRReload      BEGSR
      *
      ** Request subfile reload
      *
     C                   MOVEL     'Y'           W0RSF
      *
     C                   IF        *IN05
     C                   MOVE      *BLANKS       SPOSN
     C                   MOVE      *BLANKS       S1SEL
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProtect - Set Display Attributes for Subfile Record         *
      *                                                               *
      * Called by: SRLoad, SRSubfileRec, SRUpdate                     *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRProtect     BEGSR
      *
     C                   IF        W0PMD = 'ADD'
     C                   MOVE      '1'           *IN89
     C                   ELSE
     C                   MOVE      '0'           *IN89
     C                   ENDIF
      *
      ** Protect keys if change mode or updated record
      *
     C                   MOVEL     *IN87         *IN79
     C                   IF        *IN89
     C                   MOVE      '1'           *IN79
     C                   ENDIF
      *
     C                   MOVEL     *IN87         *IN78
     C                   IF        W0PMD = 'CHG'
     C                   MOVE      '1'           *IN78
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrScrn - Initialise Subfile Record                         *
      *                                                               *
      * Called by: SRLoad, SRDelReq                                   *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRClrScrn     BEGSR
      *
      ** Initialise subfile record
      *
     C                   EVAL      S#1DBRC = *BLANKS
     C                   EVAL      S#CRTT = *BLANKS
     C                   EVAL      S#RPCD = *BLANKS
     C                   EVAL      SRECI = *BLANKS
     C                   EVAL      STYLC = *BLANKS
     C                   EVAL      SLCD = 0
     C                   EVAL      S1SEL = *BLANKS
     C                   EVAL      SCRTT = *BLANKS
     C                   EVAL      SRPCD = *BLANKS
     C                   EVAL      SNARR = *BLANKS
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Transfer Records from SDRPCDL1 to Subfile            *
      *                                                               *
      * Called by: SRLoad, SRDelReq, SRUpdReq                         *
      *                                                               *
      * Calls    : ZEDIT                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRMove        BEGSR
      *
      ** Move SDRPCDL0 fields to subfile
      *
     C                   MOVEL     RPCRTT        S#CRTT
     C                   MOVEL     RPRPCD        S#RPCD
     C                   MOVEL     RPNARR        SNARR
     C                   MOVEL     RPRECI        SRECI
     C                   MOVEL     RPTYLC        STYLC
     C                   MOVEL     RPLCD         SLCD
      *
      ** Hold current record image for change detection
      *
     C                   MOVEL     @1DBRC        S#1DBRC
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Recipient Code Details                       *
      *                                                               *
      * Called by: SRAddReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRWrite       BEGSR
      *
     C                   MOVEL     *BLANKS       W#EROR
      *
      ** Create Recipient Codes
      *
     C                   MOVEL     'D'           RPRECI
     C                   MOVEL     S#CRTT        RPCRTT
     C                   MOVEL     S#RPCD        RPRPCD
     C                   MOVEL     SNARR         RPNARR
     C                   MOVE      'I'           RPTYLC
     C                   Z-ADD     BJRDNB        RPLCD
      *
      ** Check for duplicate primary key
      *
     C                   MOVEL     S#CRTT        KCRTT
     C                   MOVEL     S#RPCD        KRPCD
      *
     C     KEY1          SETLL     @RPCDL0                                60
      *
     C                   IF        *IN60
     C                   MOVEL     'Y'           W#EROR            1
     C                   MOVEL     'USR7535'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   WRITE     @RPCDL0                              61
      *
      ** Write error detected
      *
     C                   IF        *IN61
     C                   MOVEL     'Y'           W#EROR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete Recipient Code Details                      *
      *                                                               *
      * Called by: SRDelreq                                           *
      *                                                               *
      * Calls    : SRFmtDatO, SRZasnms                                *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
      *
      ** Delete Recipient Code Details
      *
     C                   MOVEL     *BLANKS       W#EROR
      *
      ** Set Key Fields
      *
     C                   MOVEL     SCRTT         KCRTT
     C                   MOVEL     SRPCD         KRPCD
      *
     C                   IF        W#EROR <> 'Y'
      *
     C     KEY1          CHAIN     @RPCDL0                            6061
      *
      ** Record already deleted
      *
     C                   IF        *IN60
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7536'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Record locked
      *
     C                   IF        *IN61
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7537'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Check for changed record
      *
     C                   IF        S#1DBRC <> @1DBRC
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7538'     WZMsgID
     C                   EXSR      SRZasnms
      *
      ** Release record lock
      *
     C     KEY1          SETLL     @RPCDL0                            6061
     C                   ELSE
      *
     C                   DELETE    @RPCDL0                              61
      *
      ** Delete error detected
      *
     C                   IF        *IN61
     C                   MOVEL     'Y'           W#EROR
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend  - Update Recipient Code Details                      *
      *                                                               *
      * Called by: SRUpdReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRAmend       BEGSR
      *
      ** Change Recipient Code Details
      *
     C                   MOVEL     *BLANKS       W#EROR
      *
      ** Set record data changed flag
      *
     C                   MOVE      'N'           YCRDC             1
      *
      ** Move key fields to SDRPCDL0
      *
     C                   MOVEL     S#CRTT        KCRTT
     C                   MOVEL     S#RPCD        KRPCD
      *
     C     KEY1          CHAIN     @RPCDL0                            6061
      *
      ** Record not found
      *
     C                   IF        *IN60
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7539'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Record locked
      *
     C                   IF        *IN61
     C                   MOVEL     'Y'           W#EROR
     C                   ELSE
      *
      ** Check for changed record
      *
     C                   IF        S#1DBRC <> @1DBRC
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7538'     WZMsgID
     C                   EXSR      SRZasnms
     C                   UNLOCK    SDRPCDL0                             61
     C                   ELSE
      *
      ** Store record data for null update check
      *
     C                   MOVEL     @1DBRC        YCRDCS
      *
      ** Move non-key fields to SDRPCDL0
      *
     C                   MOVE      'D'           RPRECI
     C                   MOVEL     S#CRTT        RPCRTT
     C                   MOVEL     S#RPCD        RPRPCD
     C                   MOVEL     SNARR         RPNARR
     C                   MOVEL     'A'           RPTYLC
     C                   Z-ADD     BJRDNB        RPLCD
      *
     C                   IF        @1DBRC <> YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   ENDIF
      *
      ** If changed update record otherwise release record
      *
     C                   IF        YCRDC = 'Y'
     C                   UPDATE    @RPCDL0                              61
     C                   ELSE
     C                   UNLOCK    SDRPCDL0                             61
     C                   ENDIF
      *
      ** Change error detected
      *
     C                   IF        *IN61
     C                   MOVEL     'Y'           W#EROR
     C                   ELSE
      *
      ** Update saved record image
      *
     C                   MOVEL     @1DBRC        S#1DBRC
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      * Called by: Various                                            *
      *                                                               *
      * Calls    : ZA0340                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRZasnms      BEGSR
      *
     C                   IF        WZMsgFile = *BLANKS
     C                   EVAL      WZMsgFile = ZADFMF
     C                   ENDIF
      *
     C                   CALL      'ZA0340'
     C                   PARM                    WZMsgFile        10
     C                   PARM                    WZMsgID          10
      *
     C                   EVAL      WZMsgFile = *BLANKS
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
      *
     C     SREnd         BEGSR
      *
      ** Rollback any uncommitted DBF changes
      *
     C                   ROLBK                                          60
      *
      ** Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
      ** Exit program
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *  Called by: Various                                           *
      *                                                               *
      *  Calls    : DBERRCTL - Database Error Control                 *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2001
