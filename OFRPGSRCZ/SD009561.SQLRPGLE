     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas OF Forecast Static Data Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009561 - Forecast Static Data Maintenance                  *
      *                                                               *
      *  Function:  This program maintains the Forecast Static Data   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD026922           Date 14May14               *
      *  Prev Amend No. MD026855           Date 12May14               *
      *                 CGL145A            Date 08Oct13               *
      *                 CGL145  *CREATE    Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026922 - Issue with replication                            *
      *  MD026855 - Nostro Daily Limit amount truncated               *
      *  CGL145A - Subsidiaries Daily Sweeping Forecast               *
      *  CGL145 - Subsidiaries Daily Sweeping Forecast                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    09         F9 Add/Change Mode                              *
      *    10         F10 Delete                                      *
      *    12         F12 Cancel/Previous screen                      *
      *    27         Rollup/Rolldown Key                             *
      *    31         Maintenance/Enquiry Mode                        *
      *    32         Invalid Selection                               *
      *    40         Global Error Indicator                          *
      *    41         Customer Indicator                              *
      *    42         Customer Source Account Indicator               *
      *    43         Currency Indicator                              *
      *    44         Nostro Code Indicator                           *
      *    45         Nostro Daily Limit Indicator                    *
      *    46         Retail Account Indicator                        *
      *    60         READ/READP/CHAIN Indicator                      *
      *    61         WRITE Indicator                                 *
      *    62         READC Indicator                                 *
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
      *  SRUpdate      -  Update records from subfile                 *
      *  SRDetail      -  Process action requested                    *
      *  SRAddRec      -  Process add request                         *
      *  SRDelReq      -  Process delete request                      *
      *  SRUpdReq      -  Process update request                      *
      *  SRTrailer     -  Update Control Files                        *
      *  SRMode        -  Switch between *ADD and *CHANGE modes       *
      *  SRReload      -  Request subfile reload                      *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Transfer records from SDFCSDL0 to subfile   *
      *  SRWrite       -  Create Forecast Static Data Details         *
      *  SRDelete      -  Delete Forecast Static Data Details         *
      *  SRAmend       -  Update Forecast Static Data Details         *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SRZasnmsd     -  Message with data handling subroutine       *
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Forecast Static Data Display File
     FSD009561DFCF   E             WORKSTN USROPN
     F                                     SFILE(SD009561S1:SRLRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
 
      ** GL Account by Branch
     FACCBR     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCNTLXF)
 
      ** RE Account Number file
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMTBF)
 
      ** Control File Update Index
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT                                       MD026922
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
 
      ** Review from fields
     D                 DS
     D  SPOSN                  1      5
 
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** Rundate data area
     D RUNDAT          DS
     D  WSUC                  11     11
     D  WMBIN                 13     13
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **  External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** Externally described DS for Retail ICD details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACCDX      E                     EXTFLD(QQACCD)
 
     D                 DS
     D WRETL                   1     24
     D  WBRCA                  1      3
     D  WRCUS                  4      9
     D  WRCCY                 10     12
     D  WRACD                 13     22S 0
     D  WRASQ                 23     24S 0
 
     D                 DS
     D  ACKEYK                 1     24
     D  WWBRCK                 1      3
     D  WWCUSK                 4      9
     D  WWCCYK                10     12
     D  WWACOK                13     22  0
     D  WWACSK                23     24  0
     D  RETKK                  1     10  0
     D  ACCKYK                11     24
 
     D ForcastDS     E DS                  EXTNAME(SDFCSDTD)
     D                                     PREFIX(A)
 
     D pSQL_RanOk      PR              N
     D  iSQLState                     5A   Const
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D SPCHAR          S             73    INZ('/-?:().,+0123456789')
     D UP              C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D LO              C                   CONST('abcdefghijklmnopqrstuvwxyz')
     D DIGITS          C                   CONST('0123456789')
 
     D @RUN            S              1
     D CAIN89          S              1
     D CPY2@           S             80
 
      ** Database error workfields
     D PRTCD           S              7
     D POPTN           S              7
     D PCNCD           S              2
     D PACOD           S             10
 
      ** Message file workfields - Parameters list for ZA0340 / ZA0350
     D PZMsgFile       S             10A   INZ('GBSDUSRMSG')
     D PZMsgID         S             10
     D PZMsgDta        S             45A
 
      ** General workfields
     D CAIN81          S              1
     D PMODE           S              1
     D WKIPIN          S              1
     D WFNAM           S             10
     D WCUST           S              1
     D WLRCD           S              4  0
     D WPOSN           S              5
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D W1PMD           S              3
     D W1RSF           S              1
     D W2RSF           S              1
     D W#EROR          S              1
     D W#EROR2         S              1
 
      ** Subfile workfields
     D WSkipRec        S              1
 
      ** Parameters for ZALIGN/ZEDIT
     D ZALIGNOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
     D W0RTN           S              7
     D @AJCD           S              3
 
     D WKBRCK          S              3
     D WKCUSK          S              6
     D WKCCYK          S              3
     D WKACOK          S             10  0
     D WKACSK          S              2  0
     D WKACNK          S             10  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
     C/exec SQL                                                                             MD026922
     C+ set option COMMIT = *CHG                                                            MD026922
     C/end-exec                                                                             MD026922
 
      ** Main Program
 
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page
 
     C                   EXSR      SRBuild
 
     C                   EVAL      W1RSF = 'N'
 
      ** Display screen until reload requested
 
     C                   DOW       W1RSF = 'N'
 
      ** Display screen
 
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *IN03         CASEQ     *ON           SREnd
 
     C     *IN05         CASEQ     *ON           SRReload
 
     C     *IN27         CASEQ     *ON           SRLoad
 
     C                   CAS                     SRProcess
     C                   ENDCS
 
     C                   IF        *IN03 = *ON
     C                   EXSR      SREnd
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDDO
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      *****************************************************************
     C     SRBuild       BEGSR
 
      ** Initialise & load subfile page
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD009561C1
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN79 = *OFF
 
      ** Reset Number of Records in Subfile
 
     C                   Z-ADD     0             WLRCD
 
      ** If CHANGE mode, then position file
 
     C                   EVAL      *IN82 = *OFF
 
     C                   IF        W1PMD <> 'ADD'
     C                   EVAL      WPOSN = SPOSN
 
      ** Setup key
 
     C/exec SQL
     C+ close ForecastFile
     C/end-exec
 
     C/exec sql
     C+ open ForecastFile
     C/end-exec
 
     C/exec SQL
     C+ fetch next
     C+ from ForecastFile
     C+ into :ForcastDS
     C/end-exec
 
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
 
     C                   If        %Subst(SQLState:1:2) = '02'
     C                   EVAL      *IN82 = *ON
     C                   ENDIF
 
      ** Save previous selector values
 
     C     *LIKE         DEFINE    #1POS1        WZCUST
     C                   EVAL      WZCUST = #1POS1
     C     *LIKE         DEFINE    #1POS2        WZCSSN
     C                   EVAL      WZCSSN = #1POS2
     C     *LIKE         DEFINE    #1POS3        WZCSRC
     C                   EVAL      WZCSRC = #1POS3
     C     *LIKE         DEFINE    #1POS4        WZCURR
     C                   EVAL      WZCURR = #1POS4
     C     *LIKE         DEFINE    #1POS5        WZNOTR
     C                   EVAL      WZNOTR = #1POS5
     C     *LIKE         DEFINE    #1POS6        WZRETL
     C                   EVAL      WZRETL = #1POS6
 
      ** Load subfile page
 
     C                   EXSR      SRLoad
 
      ** If no records found, display error message
 
     C                   IF        %Subst(SQLState:1:2) = '02' AND SRLRN = 0
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      *****************************************************************
     C     SRLoad        BEGSR
 
      ** Load subfile page but write empty page if add mode
 
     C                   EVAL      *IN84 = *OFF
 
      ** Re-establish fields in read-ahead record
 
     C                   IF        W1PMD <> 'ADD' and *IN27 = *ON
     C                   If        pSQL_RanOk(SQLSTATE)
 
     C/exec SQL
     C+ fetch prior
     C+ from ForecastFile
     C+ into :ForcastDS
     C/end-exec
 
     C/exec SQL
     C+ fetch next
     C+ from ForecastFile
     C+ into :ForcastDS
     C/end-exec
 
     C                   ENDIF
     C                   ENDIF
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     WLRCD         SRLRN
     C                   Z-ADD     1             WRCTR
 
      ** Load next subfile page
 
     C                   DOW       %Subst(SQLState:1:2) <> '02'
     C                             and WRCTR <= WSFPG
     C                   IF        AFCRECI = 'D'
 
     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             SRLRN
     C                   EVAL      *IN32 = *OFF
 
      ** Protect fields during Enquiry Mode
 
     C                   IF        (W1PMD <> 'ADD')
     C                   SELECT
 
     C                   WHEN      #1POS1 <> *BLANK  AND  AFCCUST <> #1POS1
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #1POS2 <> *BLANK
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      AFCCUST       @CUST
     C                   PARM      *BLANKS       @KEYSTS
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   IF        W0RTN <> *BLANKS OR BBCSSN <> #1POS2
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
 
     C                   WHEN      #1POS3 <> *BLANKS
     C                   Z-ADD     0             WXPOS             2 0
     C                   EVAL      WXPOS = %SCAN(%TRIM(#1POS3): AFCCSRC)
     C                   IF        WXPOS = 0
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
 
     C                   WHEN      #1POS4 <> *BLANK  AND  AFCCURR <> #1POS4
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #1POS5 <> *BLANK  AND AFCNOTR <> #1POS5
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #1POS6 <> *BLANK
     C                   EVAL      WRETL = *BLANKS
     C                   IF        BMRANR = 'Y'
     C                   MOVEL     AFCRETL       WRETL
     C                   ELSE
     C                   IF        AFCBRCA <> *BLANKS OR AFCRCUS <> *BLANKS
     C                             OR AFCRCCY <> *BLANKS OR AFCRACD <> 0
     C                             OR AFCRASQ <> 0
 
     C                   MOVE      AFCBRCA       WBRCA
     C                   MOVE      AFCRCUS       WRCUS
     C                   MOVE      AFCRCCY       WRCCY
     C                   MOVE      AFCRACD       WRACD
     C                   MOVE      AFCRASQ       WRASQ
     C                   ENDIF
     C                   ENDIF
     C                   IF        WRETL <> #1POS6
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDIF
 
     C                   IF        WSkipRec = 'N'
 
      ** Clear subfile fields
 
     C                   EXSR      SRClrScrn
 
      ** If CHANGE mode, load subfile fields
 
     C                   IF        W1PMD <> 'ADD'
     C                   EXSR      SRMove
 
     C                   ENDIF
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR                81
     C                   EVAL      *IN81 = *ON
 
      ** If SFLRCD invalid, note that errors present
 
     C                   IF        *IN83 = *ON and *IN40 = '0'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   WRITE     SD009561S1
 
     C                   ELSE
     C                   SUB       1             SRLRN
     C                   ENDIF
 
     C                   ENDIF
 
      ** End of File
 
     C                   IF        W1PMD <> 'ADD'
 
     C/exec SQL
     C+ fetch next
     C+ from ForecastFile
     C+ into :ForcastDS
     C/end-exec
 
     C                   IF        %Subst(SQLState:1:2) = '02'
     C                   EVAL      *IN82 = *ON
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   Z-ADD     SRLRN         WLRCD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
      ** Set screen conditioning indicators
 
     C                   IF        W1PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
 
      ** PUTOVR unless conditioned fields change
 
     C                   IF        *IN89 <> CAIN89 OR *IN81 <> CAIN81
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF
 
     C                   EVAL      CAIN89 = *IN89
     C                   EVAL      CAIN81 = *IN81
 
      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance
 
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN31 = *ON
     C                   ENDIF
 
      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance
 
      ** Set cursor by *SET CURSOR data
 
     C                   TIME                    #1TIME
     C                   WRITE     SD009561C2
     C                   WRITE     SD009561F1
     C                   EXFMT     SD009561C1
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process Screen Input                              *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
 
      ** Change of position specified
 
     C                   IF        W1PMD <> 'ADD' and WPOSN <> SPOSN
     C                             OR WZCUST <> #1POS1 OR WZCSSN <> #1POS2
     C                             OR WZCSRC <> #1POS3 OR WZCURR <> #1POS4
     C                             OR WZNOTR <> #1POS5 OR WZRETL <> #1POS6
     C
     C                   EXSR      SRReload
     C                   ENDIF
 
      ** Quit if reload requested
 
     C                   IF        W1RSF <> 'Y'
 
     C                   IF        *IN81 = *ON
     C                   EVAL      WKIPIN = 'N'
     C                   ENDIF
 
      ** Process subfile records
 
     C                   EXSR      SRProcRec
 
 
      ** Switch between *ADD/*CHANGE modes is allowed when no errors
      ** exists during update
 
     C                   IF        *IN09 = *ON and *IN40 = *OFF
     C                   EXSR      SRMode
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update Records from Subfile                        *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** Initialise subfile reload flag
 
     C                   IF        W1PMD = 'ADD'
     C                   EVAL      W1RSF = 'Y'
     C                   ELSE
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF
 
     C                   EXSR      SRDetail
 
      ** Cancel reload if errors occur
 
     C                   IF        *IN40 = *ON
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetail - Process action requested                           *
      *                                                               *
      *****************************************************************
     C     SRDetail      BEGSR
 
      ** Set off error indicators
 
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN83 = *OFF
 
     C                   EXSR      SRWrite
     C                   IF        *IN83 = *ON and *IN40 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcRec - Process Request                                   *
      *                                                               *
      *****************************************************************
     C     SRProcRec     BEGSR
 
      ** Create Forecast Static Data Details
 
     C                   EVAL      #1CUST = *BLANKS
     C                   EVAL      #1CSRC = *BLANKS
     C                   EVAL      #1CURR = *BLANKS
     C                   EVAL      #1NOTR = *BLANKS
     C                   EVAL      *IN71 = *OFF
     C                   EVAL      *IN73 = *OFF
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN89 = *ON
     C                   MOVE      *BLANKS       W#ACT             1
 
      ** Process Amend/Delete Request
 
     C                   IF        W1PMD = 'CHG' and *IN09 <> *ON
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF
     C                             and W1RSF = 'N' and WLRCD <> *ZEROS
 
      ** Check if Enquire
 
     C                   READC     SD009561S1                             62
 
     C                   DOW       *IN62 = *OFF
 
      ** Invalid Action Code
 
     C                   IF        (#1ACTN <> 'E' and #1ACTN <> 'D' and
     C                             #1ACTN <> 'A') or (#1ACTN <> 'E' and
     C                             PMODE = 'E'  )
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'CSF9853'
     C                   IF        PMODE = 'E'
     C                   EVAL      PZMsgID = 'CSF9854'
     C                   ENDIF
     C                   EXSR      SRZasnms
     C                   EVAL      *IN40 = *ON
     C                   LEAVE
     C                   ELSE
     C                   IF        #1ACTN <> ' '
 
      ** If not multi-branching, check authority to only action code.
 
     C                   IF        BJSBRC <> *BLANK
 
     C                   CALL      'ZVACTU'
     C                   PARM      #1ACTN        PActn
     C                   PARM                    PError
 
     C                   IF        PError <> *ZERO
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'CSF9006'
     C                   EXSR      SRZasnms
     C                   EVAL      *IN40 = *ON
     C                   LEAVE
     C                   ENDIF
 
     C                   ELSE
 
      ** If multi-branching, check authority to user's default branch.
 
     C                   CALL      'ZVACTBU'
     C                   PARM      #1ACTN        PActn             1
     C                   PARM      #1BRCD        PBrc              3
     C                   PARM                    PError            1 0
     C                   IF        PError = 1
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'CSF9007'
     C                   EXSR      SRZasnms
     C                   EVAL      *IN40 = *ON
     C                   LEAVE
     C                   ENDIF
 
     C                   IF        PError = 2
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'CSF9008'
     C                   EXSR      SRZasnms
     C                   EVAL      *IN40 = *ON
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W#ACT = #1ACTN
     C                   IF        #1ACTN = 'E'
     C                   EXSR      SREnqReq
     C                   ENDIF
 
      ** Check if Delete
     C                   IF        #1ACTN = 'D' and PMODE = 'M'
     C                   EXSR      SRDelReq
     C                   ENDIF
 
      ** Check if Amend
     C                   IF        #1ACTN = 'A' and PMODE = 'M'
     C                   EXSR      SRAmdReq
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   READC     SD009561S1                             62
     C                   IF        *IN62 = *OFF
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF
 
     C                   ENDDO
     C                   EVAL      W1RSF = 'Y'
 
     C                   ENDDO
 
      ** If subfile is empty, resend message
 
     C                   IF        WLRCD = *ZEROS
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        *IN09 = *ON and PMODE = 'M'
 
      ** Process Add Request
 
     C                   EVAL      W#ACT = 'I'
     C                   EXSR      SRAddReq
 
      ** Update Database
 
     C                   IF        (W#EROR =*BLANKS) AND (WKIPIN = 'Y')
     C                             and *IN12 = *OFF and *IN03 = *OFF
     C                   EXSR      SRUpdate
     C                   ENDIF
 
     C                   IF        W#EROR = *BLANKS and *IN12 = *OFF
     C                                              and *IN03 = *OFF
     C                   EVAL      W1PMD = 'ADD'
     C                   EXSR      SRTrailer
     C                   EXSR      SRReload
     C                   EVAL      *IN12 = *ON
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN89 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnqReq - Process Enquire Request                            *
      *                                                               *
      *****************************************************************
     C     SREnqReq      BEGSR
 
     C/EXEC SQL
     C+    SELECT *
     C+ into :ForcastDS
     C+ from SDFCSDTD
     C+ where FCCUST = :#1CUST and
     C+       FCCSRC = :#1CSRC and
     C+       FCCURR = :#1CURR and
     C+       FCNOTR = :#1NOTR
     C/END-EXEC
 
     C                   If        %Subst(SQLState:1:2) = '02'
 
      ** Error message if record is missing
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7517'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C                   EXSR      SRScrn2Clr
 
      ** Get Country Name for Country of Residence
 
     C                   EVAL      #2MODE = 'ENQUIRY'
     C                   EVAL      #2CUST = #1CUST
     C                   EVAL      #2CSSN = #1CSSN
 
     C                   EVAL      #2CRNM = *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #1CUST        @CUST
     C                   PARM      *BLANKS       @KEYSTS
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      #2CRNM = BBCRNM
     C                   ENDIF
 
     C                   EVAL      #2CSRC = #1CSRC
     C                   EVAL      #2CURR = #1CURR
     C                   EVAL      #2NOTR = #1NOTR
 
     C                   EVAL      #2NNAM = *BLANKS
     C                   IF        #2NOTR <> *BLANKS AND #2CURR <> *BLANKS
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUSTN
     C                   PARM      #2CURR        @CYCD
     C                   PARM      *BLANKS       @ACCD
     C                   PARM      *BLANKS       @ACSN
     C                   PARM      #2NOTR        @NONB
     C                   PARM      *BLANKS       @BRCD
     C                   PARM      *BLANKS       @CSSN
     C                   PARM      *BLANKS       @PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      #2NNAM = A7NOSN
     C                   ENDIF
     C                   ENDIF
 
 
     C                   EVAL      #2DLMT = #1DLMT
     C                   EVAL      #2RETL = #1RETL
     C                   EVAL      #2RNAM = #1RNAM
     C                   EVAL      #2NARR = #1NARR
     C                   EVAL      #2ACSA = #1ACSA
 
 
     C                   EVAL      W2RSF = 'N'
 
      ** Reset field error indicators.
 
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF
 
     C                   IF        PMODE = 'E' OR W#ACT = 'E'
     C                   EVAL      *IN38 = *ON
     C                   ENDIF
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF and
     C                             W2RSF = 'N'
     C                   WRITE     SD009561C2
     C                   WRITE     SD009561F1
     C                   EXFMT     SD009561D2
     C                   IF        *IN03 = *OFF and *IN12 = *OFF
     C                   EVAL      W2RSF = 'Y'
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
     C                   EVAL      W1RSF = 'N'
     C                   IF        PMODE = 'E'  OR W#ACT = 'E'
     C                   EVAL      *IN38 = *OFF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2 - Process Second Input Screen                         *
      *                                                               *
      *****************************************************************
     C     SRScrn2       BEGSR
 
      ** Error detected
 
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF
     C                   IF        W#ACT = 'D'
     C                   EVAL      *IN55 = *OFF
     C                   ELSE
     C                   EVAL      *IN55 = *ON
     C                   ENDIF
 
     C                   IF        *IN09 = *ON
     C                   EXSR      SRScrn2Clr
     C                   EVAL      #2MODE = 'INSERT  '
     C                   EVAL      #2CUST = #1CUST2
     C                   EVAL      #2CSRC = #1CSRC
     C                   EVAL      #2CURR = #1CURR
     C                   EVAL      #2NOTR = #1NOTR
     C                   EVAL      #2CRNM = #1CRNM
     C                   EVAL      #2CSSN = #1CSSN
     C                   EVAL      #2NNAM = #1NNAM
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      W#ACT = 'A'
     C                   EVAL      *IN37 = *ON
     C                   WHEN      W#ACT = 'E'
     C                   EVAL      *IN38 = *ON
     C                   WHEN      W#ACT = 'D'
     C                   EVAL      *IN39 = *ON
     C                   ENDSL
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF and
     C                             W1RSF = 'N'
     C                   WRITE     SD009561C2
     C                   WRITE     SD009561F1
     C                   EXFMT     SD009561D2
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      W#EROR2 = 'N'
 
      ** Reset field error indicators.
 
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF
 
      ** If Exit not pressed, validate Input Screen 2
 
     C                   IF        *IN03 = *OFF and *IN12 = *OFF and
     C                             *IN05 = *OFF and W#ACT <> 'D'
     C                   EXSR      SRScrn2v
     C                   ENDIF
 
      ** If Refresh and Add action, clear fields
 
     C                   IF        *IN05 = *ON and *IN09 = *ON
     C                   EXSR      SRScrn2Clr
     C                   EVAL      #2CUST = #1CUST2
     C                   EVAL      #2CSRC = #1CSRC
     C                   EVAL      #2CURR = #1CURR
     C                   EVAL      #2NOTR = #1NOTR
     C                   EVAL      #2CRNM = #1CRNM
     C                   EVAL      #2CSSN = #1CSSN
     C                   EVAL      #2NNAM = #1NNAM
     C                   ENDIF
 
      ** If Refresh and Amend action, restore original contents
 
     C                   IF        *IN05 = *ON and #1ACTN = 'A'
     C                   EVAL      #2DLMT = #1DLMT
     C                   EVAL      #2RETL = #1RETL
     C                   EVAL      #2RNAM = #1RNAM
     C                   EVAL      #2NARR = #1NARR
     C                   EVAL      #2ACSA = #1ACSA
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'CHG'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
     C                   IF        W#EROR2 = 'N' and *IN05 = *OFF and
     C                             *IN12 = *OFF and *IN03 = *OFF
     C                   EVAL      W1PMD = 'CHG'
     C                   IF        W#ACT = 'D' AND *IN10 = *OFF
     C                   EVAL      W1RSF = 'N'
     C                   ELSE
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
     C                   EVAL      WKIPIN = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   SELECT
     C                   WHEN      (*IN09 = *ON AND *IN12 = *OFF)
     C                             OR W#ACT = 'A'
     C                   EVAL      *IN37 = *OFF
     C                   WHEN      W#ACT = 'E'
     C                   EVAL      *IN38 = *OFF
     C                   WHEN      W#ACT = 'D'
     C                   EVAL      *IN39 = *OFF
     C                   ENDSL
 
     C                   IF        *IN12 = *ON
     C                   IF        PMODE = 'M' AND W#ACT = 'I'
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      W1RSF = 'N'
     C                   ELSE
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'CHG'
     C                   EVAL      #1CUST = *BLANKS
     C                   EVAL      #1CSRC = *BLANKS
     C                   EVAL      #1CSSN = *BLANKS
     C                   EVAL      #1CURR = *BLANKS
     C                   EVAL      #1NOTR = *BLANKS
     C                   EVAL      #1DLMT = *BLANKS
     C                   EVAL      #1RETL = *BLANKS
     C                   EVAL      #1RNAM = *BLANKS
     C                   EVAL      #1BRCD = *BLANKS
     C                   EVAL      #1NARR = *BLANKS
     C                   EVAL      #1ACSA = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *IN55 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2Clr - Clear fields for input in Second screen          *
      *                                                               *
      *****************************************************************
     C     SRScrn2Clr    BEGSR
 
     C                   EVAL      #2CUST = *BLANKS
     C                   EVAL      #2CRNM = *BLANKS
     C                   EVAL      #2CSSN = *BLANKS
     C                   EVAL      #2CSRC = *BLANKS
     C                   EVAL      #2CURR = *BLANKS
     C                   EVAL      #2NOTR = *BLANKS
     C                   EVAL      #2NNAM = *BLANKS
     C                   EVAL      #2DLMT = *BLANKS
     C                   EVAL      #2RETL = *BLANKS
     C                   EVAL      #2RNAM = *BLANKS
     C                   EVAL      #2NARR = *BLANKS
     C                   EVAL      #2ACSA = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2v - Validate input in Second screen                    *
      *                                                               *
      *****************************************************************
     C     SRScrn2v      BEGSR
 
     C                   IF        #2CURR <> *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     W0RTN
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      #2CURR        @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-add     A6NBDP        WCDPL             1 0
     C                   ENDIF
 
 
      ** Validate Nostro Daily Limit
      ** ---------------------------
 
     C                   EVAL      WSVAM = 0
 
     C                   IF        #2DLMT <> *BLANKS
 
     C                   MOVE      *BLANKS       PSCRF
 
     C                   MOVE      #2DLMT        PSCRF
     C                   MOVE      WCDPL         PNDEC
     C     15            SUB       WCDPL         PNDIG
 
     C                   CALL      'ZALIGN'      PPAR1
 
B2   C     PRTCD         IFNE      *BLANKS
 
      ** Nostro Daily limit not valid
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN45 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'XXX9025'
     C                   EXSR      SRZasnms
 
X2   C                   ELSE
 
      ** Keep Amount in a numeric field
 
     C                   MOVE      PRVAL         WSVAM            15 0
 
      ** Edit the amount
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WSVAM         ZFLD15
     C                   Z-ADD     WCDPL         ZDECS
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
 
     C********           MOVE      ZOUT21        #2DLMT                                  MD026855
     C                   EVAL      #2DLMT = %SUBST(ZOUT21:5:16)                          MD026855
E2   C                   ENDIF
     C                   ENDIF
 
 
      ** Validate Retail Account
      ** -----------------------
 
     C                   EVAL      WKBRCK  = *BLANKS
     C                   EVAL      WKCUSK  = *BLANKS
     C                   EVAL      WKCCYK  = *BLANKS
     C                   EVAL      WKACOK  = *ZERO
     C                   EVAL      WKACSK  = *ZERO
     C                   EVAL      WKACNK  = *ZERO
     C                   EVAL      #2RNAM = *BLANKS
 
     C                   IF        #2RETL <> *BLANKS
 
      ** If Blank retrieved before the 11 position, then it is an error
 
     C                   EVAL      SubForTRNN = 0
     C     ' '           SCAN      #2RETL        SubForTRNN        2 0
     C                   IF        SubForTRNN < 11 and SubForTRNN <> 0
 
      ** Retail account number not valid
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR2319'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   MOVE      #2RETL        WWRETN           21
 
      ** Format of entry must be Retail A/c Number or Full Account
 
     C     DIGITS        CHECK     WWRETN        @POSN1            3 0
     C     DIGITS        CHECK     WWRETN:10     @POSN2            3 0
     C     ' '           CHECK     WWRETN:11     @POSN3            3 0
 
     C                   SELECT
     C     @POSN1        WHENLE    11
     C     @POSN3        ANDEQ     *ZERO
 
     C     @POSN1        WHENLE    7
     C     @POSN2        ANDEQ     *ZERO
 
     C                   OTHER
 
      ** Retail account number not valid
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR2319'
     C                   EXSR      SRZasnms
     C                   ENDSL
 
      ** Account must exist and be live
 
     C                   MOVEL     *BLANKS       ACKEYK
     C                   MOVEL     #2RETL        ACKEYK
 
 B1  C     ACCKYK        IFEQ      *BLANK
     C                   Z-ADD     RETKK         WURKEY           10 0
 
     C     WURKEY        CHAIN     ACNUM                              80
 
 B2  C     *IN80         IFEQ      '1'
 
      ** Account doesn't exist in file ACNUM
      ** Retail account number not valid
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR2319'
     C                   EXSR      SRZasnms
 X2  C                   ELSE
     C     BMRANR        IFNE      'Y'
 
      ** Retail account number not valid
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR2319'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C     ACST          IFNE      ' '
 
      ** Retail account is closed
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR2318'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      **  Account exist in FILE - set up key
 
     C                   MOVE      CNUM          WWCUSK
     C                   MOVE      CCY           WWCCYK
     C                   MOVE      ACOD          WWACOK
     C                   MOVE      ACSQ          WWACSK
     C                   MOVE      BRCA          WWBRCK
 E2  C                   ENDIF
 E2  C                   ENDIF
 E2  C                   ENDIF
 E1  C                   ENDIF
 
 B1  C     *IN46         IFEQ      '0'
 
     C     WWACK3        CHAIN     ACCBR                              80
 B2  C     *IN80         IFEQ      '1'
 B2  C     ATYP          ORNE      'R'
 
      ** Retail account number not valid
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR2319'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C     ACST          IFNE      ' '
 
      ** Retail account is closed
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR2318'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
      ** Keep Account for update
 
     C                   MOVE      CNUM          WKCUSK
     C                   MOVE      CCY           WKCCYK
     C                   MOVE      ACOD          WKACOK
     C                   MOVE      ACSQ          WKACSK
     C                   MOVE      BRCA          WKBRCK
     C                   MOVE      ACNO          WKACNK
 E2  C                   ENDIF
 E2  C                   ENDIF
 E1  C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Alternative Customer Source Account validation
      ** ----------------------------------
     C                   IF        #2ACSA <> *BLANKS
     C                   MOVE      *ZEROS        XPOS
     C                   EVAL      XPOS = %CHECK(SPCHAR:#2ACSA)
 
     C                   IF        XPOS <> *ZEROS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN47 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C**********         EVAL      PZMsgID = 'USR1714'                                       CGL145A
     C                   EVAL      PZMsgID = 'XXX9029'                                       CGL145A
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAddReq - Process Add Request                                *
      *                                                               *
      *****************************************************************
     C     SRAddReq      BEGSR
 
     C                   EVAL      #1MODE = 'INSERT '
     C                   EVAL      #1CUST2 = *BLANKS
     C                   EVAL      #1CSRC = *BLANKS
     C                   EVAL      #1CURR = *BLANKS
     C                   EVAL      #1NOTR = *BLANKS
     C                   EVAL      #1DLMT = *BLANKS
     C                   EVAL      #1RETL = *BLANKS
     C                   EVAL      #1RNAM = *BLANKS
     C                   EVAL      #1BRCD = *BLANKS
     C                   EVAL      #1NARR = *BLANKS
     C                   EVAL      #1ACSA = *BLANKS
     C                   EVAL      #1CRNM = *BLANKS
     C                   EVAL      #1CSSN = *BLANKS
     C                   EVAL      #1NNAM = *BLANKS
     C                   MOVE      *BLANKS       W#CUST           10
 
     C                   EVAL      *IN37 = *ON
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF
     C                             and W1RSF = 'N'
     C                   WRITE     SD009561C2
     C                   WRITE     SD009561F1
     C                   EXFMT     SD009561D1
 
      ** Clear messages from program message queue
      ** and reset work fields
 
     C                   CALL      'ZA0250'
     C                   EVAL      W#EROR = *BLANKS
     C                   MOVEA     '00000'       *IN(40)
 
      ** If Exit not pressed, validate Input Screen 1 fields first
      ** before displaying the second Input screen
 
     C                   IF        *IN03 = *OFF and *IN12 = *OFF
     C                   IF        *IN05 = *ON
     C                   EVAL      #1CUST2 = *BLANKS
     C                   EVAL      #1CSRC = *BLANKS
     C                   EVAL      #1CURR = *BLANKS
     C                   EVAL      #1NOTR = *BLANKS
     C                   EVAL      #1CRNM = *BLANKS
     C                   EVAL      #1CSSN = *BLANKS
     C                   EVAL      #1NNAM = *BLANKS
     C                   EVAL      W#CUST = *BLANKS
     C                   ELSE
 
      ** Customer validation
      ** -------------------
 
     C                   IF        #1CUST2 = *Blanks
 
      ** Customer is mandatory
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7680'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #1CUST2       @CUST            10
     C                   PARM      *BLANKS       @KEYSTS           7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        W0RTN <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0238'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      #1CUST2 = BBCUST
     C                   EVAL      #1CRNM = BBCRNM
     C                   EVAL      #1CSSN = BBCSSN
     C                   EVAL      W#CUST = BBCUST
     C                   ENDIF
     C                   ENDIF
 
      ** Customer Source Account validation
      ** ----------------------------------
     C                   IF        #1CSRC <> *BLANKS
     C                   MOVE      *ZEROS        XPOS              2 0
     C                   EVAL      XPOS = %CHECK(SPCHAR:#1CSRC)
 
     C                   IF        XPOS <> *ZEROS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      W#EROR = 'Y'
     C**********         EVAL      PZMsgID = 'USR1714'                                       CGL145A
     C                   EVAL      PZMsgID = 'XXX9029'                                       CGL145A
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDIF
 
      ** Currency validation
      ** -------------------
 
     C                   IF        #1CURR = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0233'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Must be a valid currency
 
     C                   CALL      'AOCURRR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      #1CURR        @CCY              3
     C     SDCURR        Parm      SDCURR        DSSDY
 
      ** Invalid currency
 
B5   C     @RTCD         IFNE      *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0071'
     C                   EXSR      SRZasnms
X5   C                   ELSE
 
      ** Keep decimal places
 
     C                   EVAL      #1CURR = @CCY
     C                   Z-add     A6NBDP        WCDPL             1 0
E5   C                   ENDIF
E2   C                   ENDIF
 
      ** Nostro Code validation
      ** ----------------------
 
     C                   IF        #1NOTR = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'XXX9016'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUSTN
     C                   PARM      #1CURR        @CYCD
     C                   PARM      *BLANKS       @ACCD
     C                   PARM      *BLANKS       @ACSN
     C                   PARM      #1NOTR        @NONB
     C                   PARM      *BLANKS       @BRCD
     C                   PARM      *BLANKS       @CSSN
     C                   PARM      *BLANKS       @PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        W0RTN <> *BLANKS
 
      ** Nostro not valid
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0073'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      #1NOTR = @NONB
     C                   EVAL      #1CURR = @CYCD
     C                   EVAL      #1NNAM = A7NOSN
E6   C                   ENDIF
E2   C                   ENDIF
E2   C                   ENDIF
 
      ** Check if code already existing on file
 
     C                   IF        W#EROR = *Blanks
     C                   EVAL      #1CUST = #1CUST2
 
     C/EXEC SQL
     C+ SELECT *
     C+ into :ForcastDS
     C+ from SDFCSDTD
     C+ where FCCUST = :#1CUST and
     C+       FCCSRC = :#1CSRC and
     C+       FCCURR = :#1CURR and
     C+       FCNOTR = :#1NOTR and
     C+       FCRECI = 'D'
     C/END-EXEC
     C
     C                   If        %Subst(SQLState:1:2) <> '02'
     C                   MOVEA     '11111'       *IN(40)
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7655'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        W#EROR = *Blanks and
     C                             *IN12 = *OFF and *IN03 = *OFF
     C                             AND *IN05 = *OFF
     C                   EXSR      SRScrn2
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *IN37 = *OFF
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   IF        *IN03 = *ON or *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'ADD'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelReq - Process Delete Request                             *
      *                                                               *
      *****************************************************************
     C     SRDelReq      BEGSR
 
      ** Delete Forecast Static Data Details
 
     C                   EXSR      SRDelete
 
     C                   IF        W#EROR <> *BLANKS
 
      ** Delete unsuccessful
 
     C                   EVAL      *IN32 = *ON
     C                   MOVEA     '11'          *IN(83)
     C                   EXSR      SRMove
     C                   ELSE
 
      ** Blank out record and protect from entry
 
     C                   EXSR      SRTrailer
     C                   EXSR      SRClrScrn
     C                   EVAL      *IN84 = *OFF
 
      ** Reload subfile
 
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      #1POS1 = *Blanks
     C                   EVAL      #1POS2 = *Blanks
     C                   EVAL      #1POS3 = *Blanks
     C                   EVAL      #1POS4 = *Blanks
     C                   EVAL      #1POS5 = *Blanks
     C                   EVAL      #1POS6 = *Blanks
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmdReq - Process Update Request                             *
      *                                                               *
      *****************************************************************
 
     C     SRAmdReq      BEGSR
 
      ** Amend Forecast Static Data Details
 
     C                   EXSR      SRAmend
 
     C                   IF        W#EROR <> *BLANKS or *IN03 = *ON or
     C                             *IN12 = *ON
     C                   EVAL      *IN32 = *ON
     C                   MOVEA     '11'          *IN(83)
 
      ** Reset subfile record if changed record
 
     C                   EXSR      SRMove
     C                   ELSE
 
      ** Enable entry
 
     C                   EVAL      *IN84 = *OFF
     C                   EXSR      SRTrailer
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTrailer - Update Control Files                              *
      *                                                               *
      *****************************************************************
     C     SRTrailer     BEGSR
 
     C                   MOVEL     'SDFCSDTD'    WFNAM
     C     WFNAM         CHAIN     SDFCTLL0                           60
 
     C                   IF        *IN60 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBKEY = WFNAM
     C                   EVAL      DBPGM = 'SD009561'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      W1PMD = 'ADD'
     C                   ADD       1             AHNORC
     C                   ADD       1             AHNOIN
     C                   WHEN      #1ACTN = 'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC
     C                   WHEN      WCUST = 'Y'
     C                   ADD       1             AHNOAM
     C                   ENDSL
 
     C                   ENDIF
 
     C                   UPDATE    @AHREAU
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMode - Switch Between *ADD and *CHANGE Modes                *
      *                                                               *
      *****************************************************************
     C     SRMode        BEGSR
 
      ** Switch between *ADD/*CHANGE modes
 
     C                   IF        W1PMD <> 'ADD'
     C                   EVAL      W1PMD = 'ADD'
     C                   ELSE
     C                   EVAL      W1PMD = 'CHG'
     C                   ENDIF
 
     C                   EVAL      SPOSN = *BLANKS
 
     C                   EXSR      SRReload
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      *****************************************************************
     C     SRReload      BEGSR
 
      ** Request subfile reload
 
     C                   EVAL      W1RSF = 'Y'
 
     C                   IF        *IN05 = *ON
     C                   EVAL      SPOSN = *BLANKS
     C                   EVAL      #1ACTN = *BLANKS
     C                   EVAL      #1POS1 = *Blanks
     C                   EVAL      #1POS2 = *Blanks
     C                   EVAL      #1POS3 = *Blanks
     C                   EVAL      #1POS4 = *Blanks
     C                   EVAL      #1POS5 = *Blanks
     C                   EVAL      #1POS6 = *Blanks
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrScrn - Initialise Subfile Record                         *
      *                                                               *
      *****************************************************************
     C     SRClrScrn     BEGSR
 
      ** Initialise subfile record
 
     C                   EVAL      #1ACTN = *BLANKS
     C                   EVAL      #1CUST = *BLANKS
     C                   EVAL      #1CSRC = *BLANKS
     C                   EVAL      #1CURR = *BLANKS
     C                   EVAL      #1NOTR = *BLANKS
     C                   EVAL      #1DLMT = *BLANKS
     C                   EVAL      #1RETL = *BLANKS
     C                   EVAL      #1RNAM = *BLANKS
     C                   EVAL      #1BRCD = *BLANKS
     C                   EVAL      #1NARR = *BLANKS
     C                   EVAL      #1ACSA = *BLANKS
     C                   EVAL      #1CSSN = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Transfer Records from SDFCSDL0 to Subfile            *
      *                                                               *
      *****************************************************************
     C     SRMove        BEGSR
 
      ** Move SDFCSDL0 fields to subfile
 
     C                   EVAL      #1CUST = AFCCUST
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #1CUST        @CUST
     C                   PARM      *BLANKS       @KEYSTS
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      #1CSSN = BBCSSN
     C                   ENDIF
 
 
     C                   EVAL      #1CSRC = AFCCSRC
     C                   EVAL      #1CURR = AFCCURR
     C                   EVAL      #1NOTR = AFCNOTR
     C                   IF        AFCDLMT <> 0
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     W0RTN
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      AFCCURR       @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        W0RTN = *BLANKS
 
      ** Edit the amount
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      AFCDLMT       ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM                    ZOUT21           21
 
     C********           MOVE      ZOUT21        #1DLMT                                    MD026855
     C                   EVAL      #1DLMT = %SUBST(ZOUT21:5:16)                            MD026855
 
     C                   ENDIF
     C                   ENDIF
 
      ** Retail Account
 
     C                   MOVE      'N'           WXRETL            1
     C                   EVAL      #1RETL = *BLANKS
     C                   EVAL      #1RNAM = *BLANKS
     C                   EVAL      #1BRCD = *BLANKS
     C                   EVAL      WRETL = *BLANKS
     C                   IF        BMRANR = 'Y'
     C                   IF        AFCRETL <> *ZEROS
     c                   EVAL      WXRETL = 'Y'
     C                   MOVEL     AFCRETL       #1RETL
 
      ** Retail name
 
     C     AFCRETL       CHAIN     ACNUM                              80
     C                   IF        *IN80 = *OFF
     C                   EVAL      #1RNAM = ANAM
     C                   EVAL      #1BRCD = BRCA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WXRETL = 'N'
     C                   IF        AFCBRCA <> *BLANKS OR AFCRCUS <> *BLANKS
     C                             OR AFCRCCY <> *BLANKS OR AFCRACD <> 0
     C                             OR AFCRASQ <> 0
     C                   IF        BMRANR <> 'Y'
     C                   EVAL      WXRETL = 'Y'
     C                   MOVE      AFCBRCA       WBRCA
     C                   MOVE      AFCRCUS       WRCUS
     C                   MOVE      AFCRCCY       WRCCY
     C                   MOVE      AFCRACD       WRACD
     C                   MOVE      AFCRASQ       WRASQ
     C                   MOVEL     WRETL         #1RETL
     C                   ENDIF
 
      ** Retail name
 
     C                   MOVE      AFCRCUS       WWCUSK
     C                   MOVE      AFCRCCY       WWCCYK
     C                   MOVE      AFCRACD       WWACOK
     C                   MOVE      AFCRASQ       WWACSK
     C                   MOVE      AFCBRCA       WWBRCK
     C     WWACK3        CHAIN     ACCBR                              80
     C                   IF        *IN80 = *OFF AND ATYP = 'R'
     C                   EVAL      #1RNAM = ANAM
     C                   EVAL      #1BRCD = BRCA
     C                   IF        BMRANR = 'Y' AND WXRETL = 'N'
     C                   MOVEL     ACNO          #1RETL
     C                   EVAL      WXRETL = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Get Nostro branch if Retail branch is not available for
      **   the action code validation
 
     C                   IF        WXRETL = 'N'
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUSTN
     C                   PARM      #1CURR        @CYCD
     C                   PARM      *BLANKS       @ACCD
     C                   PARM      *BLANKS       @ACSN
     C                   PARM      #1NOTR        @NONB
     C                   PARM      *BLANKS       @BRCD
     C                   PARM      *BLANKS       @CSSN
     C                   PARM      *BLANKS       @PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      #1BRCD = A7BRCD
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      #1NARR = AFCNARR
     C                   EVAL      #1ACSA = AFCACSA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Forecast Static Data Details                 *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
 
     C                   EVAL      W#EROR = *BLANKS
 
      ** Create Forecast Static Data Details
 
     C                   IF        WSVAM = 0 AND AFCNOTR <> *BLANKS
     C                   EVAL      WSVAM = 999999999999999
     C                   ENDIF
     C     *LIKE         DEFINE    AFCTMST       WTIME
     C                   TIME                    WTIME
 
      ** Check for duplicate primary key
 
     C/EXEC SQL
     C+ SELECT *
     C+ into :ForcastDS
     C+ from SDFCSDTD
     C+ where FCCUST = :#1CUST and
     C+       FCCSRC = :#1CSRC and
     C+       FCCURR = :#1CURR and
     C+       FCNOTR = :#1NOTR and
     C+       FCRECI = 'D'
     C/END-EXEC
 
     C                   IF        %Subst(SQLState:1:2) <> '02'
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0017'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C/EXEC SQL
     C+ insert into SDFCSDTD
     C+ (
     C+   FCRECI
     C+ , FCCUST
     C+ , FCCSRC
     C+ , FCCURR
     C+ , FCNOTR
     C+ , FCDLMT
     C+ , FCBRCA
     C+ , FCRCUS
     C+ , FCRCCY
     C+ , FCRACD
     C+ , FCRASQ
     C+ , FCRETL
     C+ , FCNARR
     C+ , FCACSA
     C+ , FCLASD
     C+ , FCCHGT
     C+ , FCORED
     C+ , FCUSER
     C+ , FCTMST
     C+ )
     C+ Values
     C+ (
     C+   'D'
     C+ , :W#CUST
     C+ , :#2CSRC
     C+ , :#2CURR
     C+ , :#2NOTR
     C+ , :WSVAM
     C+ , :WKBRCK
     C+ , :WKCUSK
     C+ , :WKCCYK
     C+ , :WKACOK
     C+ , :WKACSK
     C+ , :WKACNK
     C+ , :#2NARR
     C+ , :#2ACSA
     C+ , :BJRDNB
     C+ ,  'I'
     C+ , :BJRDNB
     C+ , :PSUser
     C+ , :WTIME
     C+ )
     C/END-EXEC
      *
     C                   If        (SQLCODE <> 0)
      * Write error detected
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      *IN03 = *ON
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete Forecast Static Data Details                *
      *                                                               *
      *****************************************************************
     C     SRDelete      BEGSR
 
      ** Deletion not allowed when system setup is complete
 
     C                   EVAL      W#EROR = *BLANKS
     C                   IF        WSUC <> 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR4745'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C/EXEC SQL
     C+    SELECT *
     C+ into :ForcastDS
     C+ from SDFCSDTD
     C+ where FCCUST = :#1CUST and
     C+       FCCSRC = :#1CSRC and
     C+       FCCURR = :#1CURR and
     C+       FCNOTR = :#1NOTR and
     C+       FCRECI = 'D'
     C/END-EXEC
 
      ** Record already deleted
 
     C                   If        %Subst(SQLState:1:2) = '02'
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7602'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      #2MODE = 'DELETE'
 
      ** Move to display file fields
 
 
     C                   EVAL      #2CUST = AFCCUST
     C                   EVAL      #2CRNM = *BLANKS
     C                   EVAL      #2CSSN = *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #2CUST        @CUST
     C                   PARM      *BLANKS       @KEYSTS
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      #2CRNM = BBCRNM
     C                   EVAL      #2CSSN = BBCSSN
     C                   ENDIF
 
     C                   EVAL      #2CSRC = AFCCSRC
     C                   EVAL      #2CURR = AFCCURR
     C                   EVAL      #2NOTR = AFCNOTR
 
     C                   EVAL      #2NNAM = *BLANKS
     C                   IF        AFCNOTR <> *BLANKS AND AFCCURR <> *BLANKS
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUSTN            6
     C                   PARM      AFCCURR       @CYCD             3
     C                   PARM      *BLANKS       @ACCD            10
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM      AFCNOTR       @NONB             2
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      #2NNAM = A7NOSN
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      #2DLMT = *BLANKS
     C                   IF        AFCDLMT <> 0
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     W0RTN
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      AFCCURR       @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        W0RTN = *BLANKS
 
      ** Edit the amount
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      AFCDLMT       ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
 
     C********           MOVE      ZOUT21        #2DLMT                                     MD026855
     C                   EVAL      #2DLMT = %SUBST(ZOUT21:5:16)                             MD026855
 
     C                   ENDIF
     C                   ENDIF
 
 
     C                   MOVE      'N'           WXRETL            1
     C                   EVAL      #2RETL = *BLANKS
     C                   EVAL      #2RNAM = *BLANKS
     C                   EVAL      WRETL = *BLANKS
     C                   IF        BMRANR = 'Y'
     C                   IF        AFCRETL <> *ZEROS
     c                   EVAL      WXRETL = 'Y'
     C                   MOVEL     AFCRETL       #2RETL
 
      ** Retail name
 
     C     AFCRETL       CHAIN     ACNUM                              80
     C                   IF        *IN80 = *OFF
     C                   EVAL      #2RNAM = ANAM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WXRETL = 'N'
     C                   IF        AFCBRCA <> *BLANKS OR AFCRCUS <> *BLANKS
     C                             OR AFCRCCY <> *BLANKS OR AFCRACD <> 0
     C                             OR AFCRASQ <> 0
     C                   IF        BMRANR <> 'Y'
     C                   EVAL      WXRETL = 'Y'
     C                   MOVE      AFCBRCA       WBRCA
     C                   MOVE      AFCRCUS       WRCUS
     C                   MOVE      AFCRCCY       WRCCY
     C                   MOVE      AFCRACD       WRACD
     C                   MOVE      AFCRASQ       WRASQ
     C                   MOVEL     WRETL         #2RETL
     C                   ENDIF
 
      ** Retail name
 
     C                   MOVE      AFCRCUS       WWCUSK
     C                   MOVE      AFCRCCY       WWCCYK
     C                   MOVE      AFCRACD       WWACOK
     C                   MOVE      AFCRASQ       WWACSK
     C                   MOVE      AFCBRCA       WWBRCK
     C     WWACK3        CHAIN     ACCBR                              80
     C                   IF        *IN80 = *OFF AND ATYP = 'R'
     C                   EVAL      #2RNAM = ANAM
     C                   IF        BMRANR = 'Y' AND WXRETL = 'N'
     C                   MOVEL     ACNO          #2RETL
     C                   EVAL      WXRETL = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
 
     C                   EVAL      #2NARR = AFCNARR
     C                   EVAL      #2ACSA = AFCACSA
     C                   ENDIF
 
      ** Check if code already existing on file
 
     C                   EXSR      SRScrn2
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
      ** Set record data changed flag
 
     C                   EVAL      WCUST = 'N'
 
     C                   IF        *IN10 = *ON
     C/EXEC SQL
     C+ SELECT *
     C+ into :ForcastDS
     C+ from SDFCSDTD
     C+ where FCCUST = :#1CUST and
     C+       FCCSRC = :#1CSRC and
     C+       FCCURR = :#1CURR and
     C+       FCNOTR = :#1NOTR and
     C+       FCRECI = 'D'
     C/END-EXEC
 
      ** Record not found
 
     C                   If        %Subst(SQLState:1:2) = '02'
 
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   TIME                    WTIME
     C/EXEC SQL
     C+ UPDATE SDFCSDTD  SET FCRECI = '*', FCLASD = :BJRDNB,
     C+ FCUSER = :PSuser, FCCHGT = 'D', FCTMST = :WTIME
     C+ where FCCUST = :#1CUST and
     C+       FCCSRC = :#1CSRC and
     C+       FCCURR = :#1CURR and
     C+       FCNOTR = :#1NOTR
     C/END-EXEC
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend  - Update Forecast Static Data Details                *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
 
      ** Change Forecast Static Data Details
 
     C                   EVAL      W#EROR = *BLANKS
 
     C                   EXSR      SRScrn2Clr
 
 
     C/EXEC SQL
     C+ SELECT *
     C+ into :ForcastDS
     C+ from SDFCSDTD
     C+ where FCCUST = :#1CUST and
     C+       FCCSRC = :#1CSRC and
     C+       FCCURR = :#1CURR and
     C+       FCNOTR = :#1NOTR and
     C+       FCRECI = 'D'
     C/END-EXEC
 
      ** Record not found
 
     C                   If        %Subst(SQLState:1:2) = '02'
 
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Move to display file fields
 
     C                   EVAL      #2MODE = 'AMEND  '
     C                   EVAL      #2CUST = AFCCUST
     C                   EVAL      #2CRNM = *BLANKS
     C                   EVAL      #2CSSN = *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #2CUST        @CUST
     C                   PARM      *BLANKS       @KEYSTS
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      #2CRNM = BBCRNM
     C                   EVAL      #2CSSN = BBCSSN
     C                   ENDIF
 
     C                   EVAL      #2CSRC = AFCCSRC
     C                   EVAL      #2CURR = AFCCURR
     C                   EVAL      #2NOTR = AFCNOTR
 
     C                   EVAL      #2NNAM = *BLANKS
     C                   IF        AFCNOTR <> *BLANKS AND AFCCURR <> *BLANKS
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUSTN            6
     C                   PARM      AFCCURR       @CYCD             3
     C                   PARM      *BLANKS       @ACCD            10
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM      AFCNOTR       @NONB             2
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      #2NNAM = A7NOSN
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      #2DLMT = *BLANKS
     C                   IF        AFCDLMT <> 0
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     W0RTN
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      AFCCURR       @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        W0RTN = *BLANKS
 
      ** Edit the amount
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      AFCDLMT       ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
 
     C********           MOVE      ZOUT21        #2DLMT                                     MD026855
     C                   EVAL      #2DLMT = %SUBST(ZOUT21:5:16)                             MD026855
 
     C                   ENDIF
     C                   ENDIF
 
 
     C                   MOVE      'N'           WXRETL            1
     C                   EVAL      #2RETL = *BLANKS
     C                   EVAL      #2RNAM = *BLANKS
     C                   EVAL      WRETL = *BLANKS
     C                   IF        BMRANR = 'Y'
     C                   IF        AFCRETL <> *ZEROS
     c                   EVAL      WXRETL = 'Y'
     C                   MOVEL     AFCRETL       #2RETL
 
      ** Retail name
 
     C     AFCRETL       CHAIN     ACNUM                              80
     C                   IF        *IN80 = *OFF
     C                   EVAL      #2RNAM = ANAM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   IF        WXRETL = 'N'
     C                   IF        AFCBRCA <> *BLANKS OR AFCRCUS <> *BLANKS
     C                             OR AFCRCCY <> *BLANKS OR AFCRACD <> 0
     C                             OR AFCRASQ <> 0
     C                   IF        BMRANR <> 'Y'
     C                   EVAL      WXRETL = 'Y'
     C                   MOVE      AFCBRCA       WBRCA
     C                   MOVE      AFCRCUS       WRCUS
     C                   MOVE      AFCRCCY       WRCCY
     C                   MOVE      AFCRACD       WRACD
     C                   MOVE      AFCRASQ       WRASQ
     C                   MOVEL     WRETL         #2RETL
     C                   ENDIF
 
      ** Retail name
 
     C                   MOVE      AFCRCUS       WWCUSK
     C                   MOVE      AFCRCCY       WWCCYK
     C                   MOVE      AFCRACD       WWACOK
     C                   MOVE      AFCRASQ       WWACSK
     C                   MOVE      AFCBRCA       WWBRCK
     C     WWACK3        CHAIN     ACCBR                              80
     C                   IF        *IN80 = *OFF AND ATYP = 'R'
     C                   EVAL      #2RNAM = ANAM
     C                   IF        BMRANR = 'Y' AND WXRETL = 'N'
     C                   MOVEL     ACNO          #2RETL
     C                   EVAL      WXRETL = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
 
     C                   EVAL      #2NARR = AFCNARR
     C                   EVAL      #2ACSA = AFCACSA
     C                   ENDIF
 
 
      ** Check if code already existing on file
 
     C                   EXSR      SRScrn2
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
      ** Set record data changed flag
 
     C                   EVAL      WCUST = 'N'
 
     C                   IF        W#EROR = *Blanks and *IN12 <> *ON and
     C                             *IN03 <> *ON
 
     C/EXEC SQL
     C+ SELECT *
     C+ into :ForcastDS
     C+ from SDFCSDTD
     C+ where FCCUST = :#1CUST and
     C+       FCCSRC = :#1CSRC and
     C+       FCCURR = :#1CURR and
     C+       FCNOTR = :#1NOTR and
     C+       FCRECI = 'D'
     C/END-EXEC
 
      ** Record not found
 
     C                   If        %Subst(SQLState:1:2) = '02'
 
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Populate file fields.
 
     C                   IF        WSVAM = 0 AND AFCNOTR <> *BLANKS
     C                   EVAL      WSVAM = 999999999999999
     C                   ENDIF
     C                   TIME                    WTIME
 
     C/EXEC SQL
     C+ UPDATE SDFCSDTD SET FCLASD = :BJRDNB, FCCHGT = 'A', FCCUST = :#2CUST,
     C+ FCCSRC = :#2CSRC, FCCURR = :#2CURR, FCNOTR = :#2NOTR, FCDLMT = :WSVAM,
     C+ FCUSER = :PSuser, FCBRCA = :WKBRCK, FCRCUS = :WKCUSK, FCRCCY = :WKCCYK,
     C+ FCRACD = :WKACOK, FCRASQ = :WKACSK, FCRETL = :WKACNK, FCNARR = :#2NARR,
     C+ FCACSA = : #2ACSA, FCTMST = :WTIME
     C+ where FCCUST = :#1CUST and
     C+       FCCSRC = :#1CSRC and
     C+       FCCURR = :#1CURR and
     C+       FCNOTR = :#1NOTR and
     C+       FCRECI = 'D'
     C/END-EXEC
 
     C                   EVAL      WCUST = 'Y'
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN03 = *ON or *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      *****************************************************************
     C     SRZasnms      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnmsd - Handles the display of error messages with        *
      *             substitution values.                              *
      *                                                               *
      * Called By: SRScrn2v subroutine                                *
      *                                                               *
      * Calls:                                                        *
      * ZA0350   - Add message to pgm subfile message queue.          *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SRZasnmsd     BEGSR
 
     C                   CALL      'ZA0350'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
     C                   PARM                    PZMsgDta
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
     C                   COMMIT                                                             MD026922
 
      ** If selection mode and F3 has been pressed
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZedit - Subroutine to formate numeric field                 *
      *                                                               *
      *****************************************************************
     C     SRZedit       BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Set up copyright parameter
 
     C                   MOVEA     CPY@          CPY2@
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE
 
     C     PPAR1         PLIST
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    PSCRF            16
     C                   PARM                    PNDEC             1 0
     C                   PARM                    PNDIG             2 0
     C                   PARM      *BLANKS       PRVAL            16
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD009561'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Obtain default message file
 
      ** Call Access Program for Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'SD009561'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDRETL        PARM      SDRETL        DSFDY
 
      ** Database error
 
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDRETLPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SPCHAR =  ' ' + %TRIM(SPCHAR) + UP + LO +
     C                                       X'7D'
 
     C     WWACK3        KLIST
     C                   KFLD                    WWBRCK
     C                   KFLD                    WWCUSK
     C                   KFLD                    WWCCYK
     C                   KFLD                    WWACOK
     C                   KFLD                    WWACSK
 
 
      ** Open files for update
 
     C                   OPEN      SD009561DF
 
     C/exec sql
     C+ declare ForecastFile Scroll Cursor
     C+  for select *
     C+  from SDFCSDTD
     C+  where FCRECI = 'D'
     C+  order by
     C+  FCCUST, FCCSRC, FCCURR, FCNOTR
     C/end-exec
 
     C/exec sql
     C+ open ForecastFile
     C/end-exec
 
     C                   Z-ADD     14            WSFPG
 
      ** Set to *CHANGE mode
 
     C                   EVAL      W1PMD = 'CHG'
 
      ** Initialise subfile control
 
     C                   EVAL      SPOSN = *BLANKS
     C                   EVAL      #1RUNA = BJMRDT
     C                   EVAL      #1PGMQ = PSProcName
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1USER = PSUser
 
      ** Initialise subfile control
 
     C                   MOVEL     *BLANK        #1POS1
     C                   MOVEL     *BLANK        #1POS2
     C                   MOVEL     *BLANK        #1POS3
     C                   MOVEL     *BLANK        #1POS4
     C                   MOVEL     *BLANK        #1POS5
     C                   MOVEL     *BLANK        #1POS6
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
                                                                                            MD026922
     C                   ROLBK                                                              MD026922
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     P*****************************************************************
     P* pSQL_RanOK - See if last SQL statement ran ok.                *
     P*****************************************************************
     P pSQL_RanOk      b
     D pSQL_RanOk      pi              n
     D  iSQLState                     5a   Const
 
     C                   Return    %Subst(iSQLState:1:2) = '00'
     C                             or %Subst(iSQLState:1:2) = '01'
 
     P                 e
** CPY@
(c) Misys International Banking Systems Ltd. 2013
