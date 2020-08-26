     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FX Margin Types Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000750 - FX Margin Types Maintenance                       *
      *                                                               *
      *  Function:  This program maintains the FX Margin Types        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13091           Date 19Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CFX001   *CREATE   Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG13091 - Cannot delete FX Margin Types (Recompile)         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CFX001 - FX Margin Trading                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    09         F9 Add/Change Mode                              *
      *    27         Rollup/Rolldown Key                             *
      *    28         CHECK operation                                 *
      *    29         Highlight fields on Enquiry/Selection mode      *
      *    30         Selection Mode                                  *
      *    31         Enquiry Mode                                    *
      *    32         Invalid Selection                               *
      *    33         Invalid FX Margin Type                          *
      *    34         Invalid Currency                                *
      *    35         Invalid Description                             *
      *    36         Invalid Percentage                              *
      *    60         READ/CHAIN Indicator                            *
      *    61         READ Indicator                                  *
      *    62         READC Indicator                                 *
      *    78         Protect FX Margin Type                          *
      *    79         Protect Selection Field                         *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Subfile End (SFLEND)                            *
      *    83         Force Input Format                              *
      *    84         Subfile Next Change (SFLNXTCHG)                 *
      *    85         Global Error Indicator                          *
      *    86         PUTOVR Indicator                                *
      *    87         Enable Key Screen                               *
      *    89         Add Mode                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRSelect      -  FX Margin Type Selection                    *
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
      *  SRMove        -  Transfer records from SDMASTL1 to subfile   *
      *  SRWrite       -  Create record                               *
      *  SRDelete      -  Delete record                               *
      *  SRAmend       -  Amend record                                *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSD000750DFCF   E             WORKSTN USROPN
     F                                     SFILE(SD000750S0:#0RLRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      ** FX Margin Type Display
 
     FSDMASTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT
     F                                     RENAME(SDMASTD0:@MASTL0)
     F                                     INFDS(MASTL0)
      ** FX Margin Type Update Index
 
     FSDMASTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(SDMASTD0:@MASTL1)
     F                                     INFDS(MASTL1)
      ** FX Margin Type Retrieval Index
 
     FLEFCLTLI  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Facilities Ext File by FX Margin Types
 
     FSDCUSTLG  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Customer Details by FX Margin Types
 
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Control File Update Index
 
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
 
     D ALPHAN          C                            'ABCDEFGHIJKLMNOPQRSTUVWX-
     D                                              YZ 0123456789'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ATypCur         S              6    DIM(999)
 
      ** File Information
     D MASTL0          DS
     D  #MAST0                 9      9
     D MASTL1          DS
     D  #MAST1                 9      9
 
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Current/previous master file format fields for change control
     D @1DBRC        E DS                  EXTNAME(SDMASTPD)
 
      ** Data Structure for record fields
     D YCRDCS          DS            43
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7
     D PMODE           S              1
     D PTYPE           S              3
     D PRetCode        S              7
     D POption         S              7
     D PCurrency       S              3
     D PZMsgFile       S             10
     D PZMsgID         S             10
     D PZASIGNOK       S              1
     D PInput          S             17
     D PDigits         S              2  0
     D PDecimal        S              1  0
     D PDecSep         S              1
     D POutput         S             15
     D PSign           S              1
     D PZField         S             16
 
     D WLRCD           S              4  0
     D WPOS1           S              3
     D WPOS2           S              3
     D WKIPIN          S              1
     D WSLCTR          S              3  0
     D WNODAT          S              1
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D WNull           S              1
     D WSavCURR        S              3
     D WTypCur         S              6
     D WIx             S              3  0
     D WFile           S             10
     D WError          S              1
     D WReload         S              1
     D WDisp           S              3
     D WPercent        S              3  0
     D WRun            S              1
     D WIN89           S              1
     D WIN81           S              1
     D YCRDC           S              1
 
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
 
      ** Main Program
 
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page
 
     C                   EXSR      SRBuild
 
     C                   EVAL      WReload = 'N'
 
      ** Display screen until reload requested
 
     C     WReload       DOWEQ     'N'
 
      ** Selection Mode while no data on file
 
     C                   IF        PMODE = '?'  AND  WNODAT = 'Y'
     C                   EXSR      SRSelect
     C                   ENDIF
 
      ** Display screen
 
     C                   EXSR      SRDisplay
 
     C                   EVAL      WIx = *ZERO
     C                   CLEAR                   ATypCur
 
      ** Process response
 
     C     *IN03         CASEQ     '1'           SREnd
 
     C     *IN05         CASEQ     '1'           SRReload
 
     C     *IN09         CASEQ     '1'           SRMode
 
     C     *IN27         CASEQ     '1'           SRLoad
 
     C                   CAS                     SRProcess
     C                   ENDCS
 
     C                   ENDDO
 
     C                   ENDDO
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE
     C                   PARM                    PTYPE
 
     C     KMAST1        KLIST
     C                   KFLD                    #0POS1
     C                   KFLD                    #0POS2
 
     C     KMAST2        KLIST
     C                   KFLD                    #0TYPE
     C                   KFLD                    #0CURR
 
      ** Define message file
 
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      DBPGM = 'SD000750'
 
      ** Call Access Program for Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Open files for update
 
     C                   OPEN      SD000750DF
     C     #MAST0        IFNE      '1'
     C                   OPEN      SDMASTL0
     C                   ENDIF
     C     #MAST1        IFNE      '1'
     C                   OPEN      SDMASTL1
     C                   ENDIF
 
      ** Initialise subfile fields
 
     C                   EVAL      #0POS1 = *BLANKS
     C                   EVAL      #0POS2 = *BLANKS
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0TYLC = *BLANK
     C                   Z-ADD     *ZERO         #0LCD
     C                   Z-ADD     14            WSFPG
 
     C                   EVAL      ##PGMQ = PSProcName
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #0USER = PSUser
 
      ** Set screen indicators according to program mode
 
     C                   IF        PMODE = '?'
     C                   EVAL      *IN29 = *ON
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
 
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN29 = *ON
     C                   EVAL      *IN31 = *ON
     C                   ENDIF
 
      ** Set to *CHANGE mode
 
     C                   EVAL      WDisp = 'CHG'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSelect - FX Margin Type Selection                          *
      *****************************************************************
 
     C     SRSelect      BEGSR
 
     C     KMAST2        CHAIN     SDMASTL0
 
      ** Record not found
 
     C                   IF        NOT %FOUND(SDMASTL0)
     C                   EVAL      PRTCD = '*ERROR '
     C                   EVAL      PTYPE = *BLANKS
     C                   ELSE
     C                   EVAL      PTYPE = MSTYPE
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBuild - Initialise and Load Subfile Page                   *
      *****************************************************************
 
     C     SRBuild       BEGSR
 
      ** Initialise & load subfile page
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000750C0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *ON
 
      ** Reset Number of Records in Subfile
 
     C                   Z-ADD     0             WLRCD
 
      ** If CHANGE mode, then position file
 
     C                   IF        WDisp = 'CHG'
     C                   EVAL      WPOS1 = #0POS1
     C                   EVAL      WPOS2 = #0POS2
 
      ** Setup key
 
     C     KMAST1        SETLL     @MASTL1                            82
 
     C                   READ      @MASTL1                                82
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
 
      ** Save previous selector value
 
     C     *LIKE         DEFINE    #0POS1        WZTYPE
     C     *LIKE         DEFINE    #0POS2        WZTYP2
     C                   EVAL      WZTYPE = #0POS1
     C                   EVAL      WZTYP2 = #0POS2
 
      ** Load subfile page
 
     C                   EXSR      SRLoad
 
      ** If no records found, display error message
 
     C                   IF        *IN82 = *ON  AND  #0RLRN = 0
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLoad - Load Subfile Page                                   *
      *****************************************************************
 
     C     SRLoad        BEGSR
 
     C                   EVAL      *IN84 = *OFF
 
      ** Re-establish fields in read-ahead record
 
     C                   IF        WDisp = 'CHG'  AND  *IN27 = *ON  AND
     C                             *IN82 = *OFF
     C                   READP     @MASTL1                                60
     C                   READ      @MASTL1                                60
     C                   ENDIF
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     WLRCD         #0RLRN
     C                   Z-ADD     1             WRCTR
 
      ** Load next subfile page
 
     C                   DOW       *IN82 = *OFF  AND  WRCTR <= WSFPG
 
     C                   ADD       1             #0RLRN
     C                   MOVEA     '00000'       *IN(32)
     C                   EVAL      *IN87 = *OFF
 
      ** Clear subfile fields
 
     C                   EXSR      SRClrScrn
 
     C                   IF        WDisp = 'CHG'
 
      ** Load subfile fields, then validate
 
     C                   EXSR      SRMove
     C                   EXSR      SRValidate
 
      ** If SFLRCD invalid, note that errors are present
 
     C                   IF        *IN83 = *ON  AND  *IN85 = *OFF
     C                   EVAL      *IN85 = *ON
     C                   ENDIF
 
     C                   READ      @MASTL1                                82
     C                   ENDIF
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR
     C                   EVAL      *IN81 = *ON
     C                   EXSR      SRProtect
 
     C                   WRITE     SD000750S0
 
     C                   ENDDO
 
     C                   Z-ADD     #0RLRN        WLRCD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDisplay - Display Subfile                                  *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
      ** Set screen conditioning indicators
 
     C                   IF        WDisp = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
 
      ** PUTOVR unless conditioned fields change
 
     C                   EVAL      *IN86 = *ON
     C                   IF        *IN89 <> WIN89  OR  *IN81 <> WIN81
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF
 
     C                   EVAL      WIN89 = *IN89
     C                   EVAL      WIN81 = *IN81
 
      ** Set cursor by *SET CURSOR data
 
     C                   TIME                    #0TIME
     C                   WRITE     SD000750C1
     C                   WRITE     SD000750F0
     C                   EXFMT     SD000750C0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRProcess - Process Screen Input                             *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Change of position specified
 
     C                   IF        WDisp = 'CHG'  AND  WPOS1 <> #0POS1  AND
     C                             *IN09 = *OFF   OR
     C                             WDisp = 'CHG'  AND  WPOS2 <> #0POS2  AND
     C                             *IN09 = *OFF
     C                   EXSR      SRReload
     C                   ENDIF
 
      ** Quit if reload requested
 
     C     WReload       IFNE      'Y'
 
     C                   IF        *IN81 = *ON
     C                   EVAL      WKIPIN = 'N'
 
      ** Process subfile records
 
     C                   EXSR      SRSubfileRec
 
      ** Update DBF from subfile
 
     C                   IF        *IN85 = *OFF  AND  WKIPIN = 'Y'
     C                   EXSR      SRUpdate
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSubfileRec - Process Modified Subfile Record               *
      *****************************************************************
 
     C     SRSubfileRec  BEGSR
 
      ** Process modified subfile record
 
     C                   READC     SD000750S0                             62
 
     C                   DOW       *IN62 = *OFF
     C                   EXSR      SRAction
     C                   EVAL      *IN87 = *OFF
     C                   EXSR      SRProtect
 
     C                   EVAL      *IN84 = *ON
     C                   UPDATE    SD000750S0
     C                   EVAL      *IN84 = *OFF
 
     C                   READC     SD000750S0                             62
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAction - Process Subfile Record                            *
      *****************************************************************
 
     C     SRAction      BEGSR
 
      ** Set off error indicators
 
     C                   MOVEA     '00000'       *IN(32)
     C                   MOVEA     '00'          *IN(83)
 
      ** Check for null record if action is Insert
 
     C                   IF        WDisp = 'ADD'
     C                   EXSR      SRNullRecord
     C                   ENDIF
 
      ** If not null record, continue
 
     C     WNull         IFNE      'Y'
     C                   EVAL      WKIPIN = 'Y'
 
      ** Validate record
 
     C                   EXSR      SRValidKey
 
      ** Seton Global Error Indicator if error exists
 
     C                   IF        *IN83 = *ON
     C                   EVAL      *IN85 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRNullRecord - Check for Null Record                         *
      *****************************************************************
 
     C     SRNullRecord  BEGSR
 
     C                   EVAL      WNull = 'N'
 
     C     #0TYPE        IFEQ      *BLANKS
     C     #0CURR        ANDEQ     *BLANKS
     C     #0DESC        ANDEQ     *BLANKS
     C     #0PERC        ANDEQ     *BLANKS
     C                   EVAL      WNull = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRValidKey - Validate Subfile Record                         *
      *****************************************************************
 
     C     SRValidKey    BEGSR
 
      ** FX Margin Type must not be blank
 
     C                   IF        #0TYPE = *BLANKS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR4027'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Description must be specified
 
     C                   IF        #0DESC = *BLANKS
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR4028'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Validate Action
 
     C                   IF        #0SELC <> 'D'  AND  #0SELC <> *BLANKS  AND
     C                             PMODE = 'M'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9162'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        PMODE = '?'  AND  #0SELC = '1'
     C                   EVAL      WNODAT = 'Y'
     C                   ADD       1             WSLCTR
     C                   IF        WSLCTR > 1
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9174'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** For selection mode, selection field must be '1'
 
     C                   IF        PMODE = '?'  AND  #0SELC <> '1'  AND
     C                             #0SELC <> *BLANKS
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9173'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Validate subfile record relations
 
     C                   EXSR      SRValidate
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRValidate - Validate Subfile Record Relations               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
      ** FX Margin Type must contain letters, digits,
      ** and blanks only (but not all blanks)
 
     C                   IF        #0TYPE <> *BLANKS
 
     C     ALPHAN        CHECK     #0TYPE                                 28
 
     C                   IF        *IN28 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR4030'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** If entered, the currency must exist in the system
 
     C                   IF        #0CURR <> *BLANKS
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      #0CURR        PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   SELECT
     C                   WHEN      PRetCode <> *BLANKS    AND
     C                             PRetCode <> '*NRF   '  AND
     C                             PRetCode <> '*NOSEL '
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = #0CURR
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
 
     C                   WHEN      PRetCode = '*NRF   '
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR0235'
     C                   EXSR      SRZasnms
 
     C                   WHEN      PRetCode = '*NOSEL '
     C                   EVAL      #0CURR = ##CURR
 
     C                   WHEN      PRetCode = *BLANKS
     C                   EVAL      #0CURR = PCurrency
     C                   ENDSL
     C                   ENDIF
 
      ** If entered, the percentage must range from 0 to 100; default is 0
 
     C                   IF        #0PERC <> *BLANKS
     C                   EVAL      WPercent = 0
 
     C                   CALLB     'ZASIGN'
     C                   PARM      *BLANKS       PZASIGNOK
     C                   PARM      #0PERC        PInput
     C                   PARM      3             PDigits
     C                   PARM      0             PDecimal
     C                   PARM      *BLANK        PDecSep
     C                   PARM      *BLANKS       POutput
     C                   PARM      *BLANK        PSign
 
     C                   IF        PZASIGNOK = 'Y'
     C                   MOVE      POutput       WPercent
     C                   ENDIF
 
     C                   IF        PZASIGNOK = 'N'  OR  WPercent > 100
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR4029'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   MOVE      POutput       PZField
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM      0             PDecimal
     C                   MOVE      PZField       #0PERC
     C                   ENDIF
     C                   ENDIF
 
      ** Validate deletion of FX margin type w/ blank currency
 
     C                   IF        #0SELC = 'D'
     C                   IF        #0TYPE <> *BLANKS  AND  #0CURR = *BLANKS
 
      ** Deletion of an FX margin type with a blank currency is not allowed
      ** if the FX margin type is defined in any facility or customer
 
     C     #0TYPE        CHAIN     LEFCLTLI
 
     C                   IF        %FOUND(LEFCLTLI)
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR4037'
     C                   EXSR      SRZasnms
 
     C                   ELSE
     C     #0TYPE        CHAIN     SDCUSTLG
 
     C                   IF        %FOUND(SDCUSTLG)
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR4037'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WDisp = 'ADD'
 
      ** Check for duplicate records
 
     C     KMAST2        CHAIN     SDMASTL0
 
     C                   IF        %FOUND(SDMASTL0)
     C                   MOVEA     '1111'        *IN(33)
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR4031'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   UNLOCK    SDMASTL0
 
      ** FX Margin Type/Currency combination must not be specified more than
      ** once in the 'ADD' mode subfile screen
 
     C                   EVAL      WTypCur = *BLANKS
     C                   MOVEL     #0TYPE        WTypCur
     C                   MOVE      #0CURR        WTypCur
     C     WTypCur       LOOKUP    ATypCur                                77
     C                   IF        *IN77 = *ON
     C                   MOVEA     '11'          *IN(33)
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR4038'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ADD       1             WIx
     C                   EVAL      ATypCur(WIx) = WTypCur
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRUpdate - Update Records from Subfile                       *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
      ** Initialise subfile reload flag
 
     C                   IF        WDisp = 'ADD'
     C                   EVAL      WReload = 'Y'
     C                   ELSE
     C                   EVAL      WReload = 'N'
     C                   ENDIF
 
      ** Process all modified subfile records
 
     C                   READC     SD000750S0                             62
 
     C                   DOW       *IN62 = *OFF
     C                   EXSR      SRDetail
 
      ** Rollback any DBF changes if error occur
 
     C                   IF        WError <> *BLANKS
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
      ** Set screen conditioning indicators
 
     C                   EXSR      SRProtect
 
     C                   EVAL      *IN84 = *ON
     C                   UPDATE    SD000750S0
     C                   EVAL      *IN84 = *OFF
 
     C                   READC     SD000750S0                             62
     C                   ENDDO
 
      ** Cancel reload if errors occur
 
     C                   IF        *IN85 = *ON
     C                   EVAL      WReload = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDetail - Process action requested                          *
      *****************************************************************
 
     C     SRDetail      BEGSR
 
      ** Set off error indicators
 
     C                   MOVEA     '00000'       *IN(32)
     C                   EVAL      *IN83 = *OFF
 
      ** Process add request
 
     C                   IF        WDisp = 'ADD'
 
     C                   EXSR      SRNullRecord
     C                   IF        WNull <> 'Y'
     C                   EXSR      SRAddReq
     C                   ENDIF
 
     C                   ELSE
 
      ** Process delete request
 
     C                   IF        #0SELC = 'D'
     C                   EXSR      SRDelReq
     C                   ELSE
 
      ** Process change request
 
     C                   EXSR      SRUpdReq
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN83 and *IN85 = *OFF
     C                   EVAL      *IN85 = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAddReq - Process Add Request                               *
      *****************************************************************
 
     C     SRAddReq      BEGSR
 
     C                   EXSR      SRWrite
 
      ** Error detected
 
     C                   IF        WError <> *BLANKS
     C                   MOVEA     '11111'       *IN(33)
     C                   MOVEA     '11'          *IN(83)
     C                   EVAL      *IN87 = *OFF
     C                   ELSE
     C                   EVAL      *IN87 = *ON
     C                   EXSR      SRTrailer
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDelReq - Process Delete Request                            *
      *****************************************************************
 
     C     SRDelReq      BEGSR
 
     C                   EXSR      SRDelete
 
     C                   IF        WError <> *BLANKS
 
      ** Delete unsuccessful
 
     C                   MOVEA     '11111'       *IN(32)
     C                   MOVEA     '11'          *IN(83)
     C                   EVAL      *IN87 = *OFF
     C                   EXSR      SRMove
     C                   ELSE
 
      ** Blank out record and protect from entry
 
     C                   EXSR      SRTrailer
     C                   EXSR      SRClrScrn
     C                   EVAL      *IN87 = *ON
 
      ** Reload subfile
 
     C                   EVAL      WReload = 'Y'
     C                   EVAL      #0POS1 = *BLANKS
     C                   EVAL      #0POS2 = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRUpdReq - Process Update Request                            *
      *****************************************************************
 
     C     SRUpdReq      BEGSR
 
     C                   EXSR      SRAmend
 
     C                   IF        WError <> *BLANKS
     C                   MOVEA     '11111'       *IN(32)
     C                   EVAL      *IN87 = *OFF
     C                   MOVEA     '11'          *IN(83)
 
      ** Reset subfile record if changed record
 
     C                   EXSR      SRMove
     C                   ELSE
 
      ** Enable entry
 
     C                   EVAL      *IN87 = *OFF
     C                   EXSR      SRTrailer
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRTrailer - Update Control Files                             *
      *****************************************************************
 
     C     SRTrailer     BEGSR
 
     C                   EVAL      WFile = 'SDMASTPD'
 
     C     WFile         CHAIN     SDFCTLL0
 
     C                   IF        NOT %FOUND(SDFCTLL0)
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBKEY  = WFile
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      WDisp = 'ADD'
     C                   ADD       1             AHNORC
     C                   ADD       1             AHNOIN
 
     C                   WHEN      #0SELC = 'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC
 
     C                   WHEN      YCRDC = 'Y'
     C                   ADD       1             AHNOAM
     C                   ENDSL
 
     C                   ENDIF
 
     C                   UPDATE    @AHREAU
 
     C                   COMMIT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRMode - Switch Between *ADD and *CHANGE Modes               *
      *****************************************************************
 
     C     SRMode        BEGSR
 
      ** Switch between *ADD/*CHANGE modes
 
     C                   IF        WDisp <> 'ADD'
     C                   EVAL      WDisp = 'ADD'
     C                   ELSE
     C                   EVAL      WDisp = 'CHG'
     C                   ENDIF
 
     C                   EVAL      #0POS1 = *BLANKS
     C                   EVAL      #0POS2 = *BLANKS
 
     C                   EXSR      SRReload
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRReload - Request Subfile Reload                            *
      *****************************************************************
 
     C     SRReload      BEGSR
 
      ** Request subfile reload
 
     C                   EVAL      WReload = 'Y'
 
     C                   IF        *IN05 = *ON
     C                   EVAL      #0POS1 = *BLANKS
     C                   EVAL      #0POS2 = *BLANKS
     C                   EVAL      #0SELC = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRProtect - Set Display Attributes for Subfile Record        *
      *****************************************************************
 
     C     SRProtect     BEGSR
 
     C                   SELECT
 
      ** Enquiry Mode
 
     C                   WHEN      PMODE = 'E'
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN87 = *ON
 
      ** Selection Mode
 
     C                   WHEN      PMODE = '?'
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN79 = *OFF
     C                   EVAL      *IN87 = *ON
 
      ** In 'ADD' mode, disable action field
 
     C                   WHEN      PMODE = 'M'
     C                   IF        WDisp = 'ADD'
     C                   EVAL      *IN78 = *OFF
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN79 = *OFF
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRClrScrn - Initialise Subfile Record                        *
      *****************************************************************
 
     C     SRClrScrn     BEGSR
 
     C                   EVAL      ##DBRC = *BLANKS
     C                   EVAL      ##CURR = *BLANKS
     C                   EVAL      #0TYPE = *BLANKS
     C                   EVAL      #0TYLC = *BLANKS
     C                   EVAL      #0LCD  = *ZEROS
     C                   EVAL      #0SELC = *BLANKS
     C                   EVAL      #0TYPE = *BLANKS
     C                   EVAL      #0CURR = *BLANKS
     C                   EVAL      #0DESC = *BLANKS
     C                   EVAL      #0PERC = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRMove - Transfer Records from SDMASTL1 to Subfile           *
      *****************************************************************
 
     C     SRMove        BEGSR
 
     C                   EVAL      #0TYPE = MSTYPE
     C                   EVAL      #0CURR = MSCURR
     C                   EVAL      ##CURR = MSCURR
     C                   EVAL      #0DESC = MSDESC
     C                   MOVE      MSPERC        #0PERC
 
      ** Hold current record image for change detection
 
     C                   MOVE      @1DBRC        ##DBRC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRWrite - Create a record                                    *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   EVAL      WError = *BLANKS
     C                   EVAL      MSTYPE = #0TYPE
     C                   EVAL      MSTYLC = 'I'
     C                   Z-ADD     BJRDNB        MSLCD
     C                   EVAL      MSCURR = #0CURR
     C                   EVAL      MSDESC = #0DESC
     C                   MOVE      #0PERC        MSPERC
 
     C                   WRITE     @MASTL0                              61
 
      ** Write error detected
 
     C                   IF        *IN61
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  SRDelete - Delete record                                     *
      *****************************************************************
 
     C     SRDelete      BEGSR
 
     C                   EVAL      WError = *BLANKS
 
     C     KMAST2        CHAIN(E)  SDMASTL0
 
      ** Record already deleted
 
     C                   IF        NOT %FOUND(SDMASTL0)
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USR7602'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Record locked
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USR7603'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Check for changed record
 
     C                   IF        ##DBRC <> @1DBRC
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USR7604'
     C                   EXSR      SRZasnms
 
      ** Release record lock
 
     C                   UNLOCK    SDMASTL0
 
     C                   ELSE
 
     C                   DELETE(E) @MASTL0
 
      ** Delete error detected
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAmend - Amend record                                       *
      *****************************************************************
 
     C     SRAmend       BEGSR
 
      ** Set record data changed flag
 
     C                   EVAL      YCRDC = 'N'
     C                   EVAL      WError = *BLANKS
 
     C     KMAST2        CHAIN(E)  SDMASTL0
 
      ** Record not found
 
     C                   IF        NOT %FOUND(SDMASTL0)
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Record locked
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   ELSE
 
      ** Check for changed record
 
     C                   IF        ##DBRC <> @1DBRC
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USR7604'
     C                   EXSR      SRZasnms
     C                   UNLOCK    SDMASTL0
     C                   ELSE
 
      ** Store record data for null update check
 
     C                   EVAL      YCRDCS = @1DBRC
 
      ** Move screen fields to file
 
     C                   EVAL      MSTYPE = #0TYPE
     C                   EVAL      MSCURR = #0CURR
     C                   EVAL      MSDESC = #0DESC
     C                   MOVE      #0PERC        MSPERC
     C                   EVAL      MSTYLC = 'A'
     C                   Z-ADD     BJRDNB        MSLCD
 
     C                   IF        @1DBRC <> YCRDCS
     C                   EVAL      YCRDC = 'Y'
     C                   ENDIF
 
      ** If record changed, update; otherwise release record
 
     C                   IF        YCRDC = 'Y'
     C                   UPDATE(E) @MASTL0
     C                   ELSE
     C                   UNLOCK(E) SDMASTL0
     C                   ENDIF
 
      ** Change error detected
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   ELSE
 
      ** Update saved record image
 
     C                   MOVE      @1DBRC        ##DBRC
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRZasnms - Message Handling Subroutine                       *
      *****************************************************************
 
     C     SRZasnms      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SREnd - End Program                                          *
      *****************************************************************
 
     C     SREnd         BEGSR
 
      ** Rollback any uncommitted DBF changes
 
     C                   ROLBK                                          60
 
      ** If selection mode and F3 has been pressed
 
     C                   IF        PMODE = '?'
     C                   EVAL      PRTCD = '*NOSEL '
     C                   EVAL      PTYPE = *BLANKS
     C                   ENDIF
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR   -  Error Handling Subroutine                         *
      *****************************************************************
 
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
 
      *****************************************************************
      /EJECT
** CPY@
(c) Finastra International Limited 2003
