     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Generic Posting Interface Ctl Maintenance')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000123 - Generic Posting Interface Control Data Maintenance*
      *                                                               *
      *  Function:  This program maintains the Interface File Details *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CGL160  *CREATE    Date 10Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL160 - Cheque Details Upload via Generic Posting Interface *
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
      *    33         Invalid Unique Interface Reference              *
      *    34         Invalid Interface Description                   *
      *    35         Invalid Interface File Name                     *
      *    40         Global Error Indicator                          *
      *    41         Invalid Unique Interface Reference              *
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
      *  SRMode        -  Switch between *ADD and *CHANGE modes       *
      *  SRReload      -  Request subfile reload                      *
      *  SRProtect     -  Set display attributes for subfile record   *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Transfer records from SDGPICL2 to subfile   *
      *  SRWrite       -  Create Posting Interface Control Record     *
      *  SRDelete      -  Delete Posting Interface Control Record     *
      *  SRAmend       -  Update Posting Interface Control Record     *
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
 
     FSD000123DFCF   E             WORKSTN USROPN
     F                                     SFILE(SD000123S1:SRLRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
 
      ** GL Generic Posting Interface Control Data Update Index
     FGLGPICL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(GPICL0)
     F                                     COMMIT
     F                                     RENAME(GLGPICD0:@GPICL0)
 
      ** GL Generic Posting Interface Control Data Retrieval Index
     FGLGPICL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(GPICL2)
     F                                     RENAME(GLGPICD0:@GPICL2)
      *
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
 
     D AFLD10          S              1    DIM(10)
 
      ** Review from fields
     D                 DS
     D  SPOSN                  1      5
     D WCTRTST         DS
     D  WTestF1                1      1A
     D  WTestF2                2      2A
 
      ** File Information
     D GPICL0          DS
     D  #GPIC0                 9      9
     D GPICL2          DS
     D  #GPIC1                 9      9
 
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** Rundate data area
     D RUNDAT          DS
     D  WSUC                  11     11
     D  WMBIN                 13     13
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Account Code Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** External data structure for Transaction Type Details
     D SDTRNT        E DS                  EXTNAME(TABLETZ)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS for SAR Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D CAIN89          S              1
     D CPY2@           S             80
 
      ** Database error workfields
     D PRTCD           S              7
     D POPTN           S              7
     D PCNCD           S              2
     D PACOD           S             10
 
      ** Message file workfields - Parameters list for ZA0340 / ZA0350.
     D PZMsgFile       S             10A   INZ('GBSDUSRMSG')
     D PZMsgID         S             10A
     D PZMsgDta        S             45A
     D PZMsgTyp        S              7A
     D PZRelQ          S              5A
     D PZPrgmQ         S             10A
 
      ** General workfields
     D CAIN81          S              1
     D PMODE           S              1
     D CGL160          S              1A
 
      ** Screen field original contents save variables.
     D P2SARN          S              6
     D P2MIDF          S              1
     D P2DESC          S             30
     D P2IFIL          S             10
     D P2ILIB          S             10
     D P2TFIL          S             10
     D P2TLIB          S             10
     D P2IDTQ          S             10
     D P2ODTQ          S             10
     D P2WAIT          S              5
     D P2FAIL          S              1
     D P2CLRF          S              1
     D P2SPOS          S              7
     D P2GETP          S              1
     D P2SUSP          S              1
     D P2INVL          S              1
     D P2PVDT          S              1
     D P2RPTI          S              1
     D P2RIAC          S             10
     D P2UITT          S              5
     D P2UIAC          S             10
     D P2BLAC          S              1
     D P2INAC          S              1
     D P2RFAC          S              1
     D P2BKAC          S              1
     D P2NSF           S              1
     D P2CQST          S              1
     D P2CQRG          S              1
     D P2CQPR          S              1
     D P2CQNX          S              1
 
     D WKIPIN          S              1
     D WCTRT           S              1
     D WCTRR           S              2
     D WCTRN           S             30
     D WDATEN          S              6  0
     D WDATEA          S              6
     D WLRCD           S              4  0
     D WNODAT          S              1
     D WPOSN           S              5
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D W1PMD           S              3
     D W1RSF           S              1
     D W2RSF           S              1
     D W#EROR          S              1
     D W#EROR2         S              1
      *
      ** QDCXLATE workfields
     D WQA5N           S              5  0
     D WQB10X          S             10
     D WQC10X          S             10
 
      ** QCLSCAN workfields
     D WQA3N           S              3  0
     D WQB3N           S              3  0
     D WQC3N           S              3  0
     D WQG3N           S              3  0
     D WQD1            S              1
     D WQE1            S              1
     D WQF1            S              1
 
      ** Subfile workfields
     D WSkipRec        S              1
     D WKeyScrn        S              1
     D WDetScrn        S              1
     D WValid          S              1
 
      ** Parameters for ZALIGN/ZEDIT
     D ZRTN            S              7
     D ZFIELD          S             16
     D ZAFLD           S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
      *
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
     C                   WRITE     SD000123C1
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      WKeyScrn = 'N'
     C                   EVAL      WDetScrn = 'N'
     C                   EVAL      *IN79 = *OFF
 
      ** Reset Number of Records in Subfile
 
     C                   Z-ADD     0             WLRCD
 
      ** If CHANGE mode, then position file
 
 
     C                   IF        W1PMD <> 'ADD'
     C                   EVAL      WPOSN = SPOSN
 
      ** Setup key
 
     C     #1POS1        SETLL     @GPICL2                            82
 
     C                   READ      @GPICL2                                82
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
 
      ** Save previous selector values
 
     C     *LIKE         DEFINE    #1POS1        WZSARN
     C                   EVAL      WZSARN = #1POS1
     C     *LIKE         DEFINE    #1POS2        WZDESC
     C                   EVAL      WZDESC = #1POS2
     C     *LIKE         DEFINE    #1POS3        WZIFIL
     C                   EVAL      WZIFIL = #1POS3
 
      ** Translate search mask for text field
 
     C     *LIKE         DEFINE    #1POS2        WQDESC
 
     C                   CALL      'QDCXLATE'
     C                   PARM      30            WQA5N
     C                   PARM      #1POS2        WQDESC
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
 
      ** Load subfile page
 
     C                   EXSR      SRLoad
 
      ** If no records found, display error message
 
     C                   IF        *IN82 = *ON and SRLRN = 0
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
 
     C                   IF        W1PMD <> 'ADD' and *IN27 = *ON and
     C                             *IN82 = '0'
     C                   READP     @GPICL2                                60
     C                   READ      @GPICL2                                60
     C                   ENDIF
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     WLRCD         SRLRN
     C                   Z-ADD     1             WRCTR
 
      ** Load next subfile page
 
     C                   DOW       *IN82 = '0' and WRCTR <= WSFPG
 
     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             SRLRN
     C                   MOVEA     '000000'      *IN(32)
 
      ** Protect fields during Enquiry Mode
 
     C                   IF        (W1PMD <> 'ADD')
     C                   SELECT
 
     C                   WHEN      #1POS1 <> *BLANK  AND  GPSARN <> #1POS1
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #1POS3 <> *BLANK  AND  GPIFIL <> #1POS3
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #1POS2 <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    GPDESC
     C                   PARM      30            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQDESC
     C                   PARM      30            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
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
 
      ** Set screen conditioning indicators
 
     C                   EXSR      SRProtect
 
     C                   WRITE     SD000123S1
 
     C                   ELSE
     C                   SUB       1             SRLRN
     C                   ENDIF
 
      ** End of File
 
     C                   IF        W1PMD <> 'ADD'
     C                   READ      @GPICL2                                82
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
     C                   WRITE     SD000123C2
     C                   WRITE     SD000123F1
     C                   EXFMT     SD000123C1
 
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
     C                             OR WZSARN <> #1POS1  OR  WZDESC <> #1POS2
     C                             OR WZIFIL <> #1POS3
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
 
      ** Rollback any DBF changes if error occur
 
     C                   IF        W#EROR <> *BLANKS
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
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
 
     C                   MOVEA     '000000'      *IN(32)
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
 
      ** Create Generic Posting Interface Control File Record
 
     C                   EVAL      #1SARN = *BLANKS
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN71 = *OFF
     C                   EVAL      *IN73 = *OFF
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN89 = *ON
 
      ** Process Amend/Delete Request
     C                   IF        W1PMD = 'CHG' and *IN09 <> *ON
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF
     C                             and W1RSF = 'N' and WLRCD <> *ZEROS
 
      ** Check if Enquire
     C                   READC     SD000123S1                             62
 
     C                   DOW       *IN62 = *OFF
      ** Invalid Action Code
     C                   IF        (#1ACTN <> 'E' and #1ACTN <> 'D' and
     C                             #1ACTN <> 'A') or (#1ACTN <> 'E' and
     C                             PMODE = 'E'  )
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'USR4429'
     C                   IF        PMODE = 'E'
     C                   EVAL      PZMsgID = 'USR7710'
     C                   ENDIF
     C                   EXSR      SRZasnms
     C                   EVAL      *IN40 = *ON
     C                   LEAVE
     C                   ELSE
 
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
 
     C                   READC     SD000123S1                             62
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
     C                   EXSR      SRAddReq
 
      ** Update Database
     C                   IF        (W#EROR =*BLANKS) AND (WKIPIN = 'Y')
     C                             and *IN12 = *OFF and *IN03 = *OFF
     C                   EXSR      SRUpdate
     C                   ENDIF
 
     C                   IF        W#EROR = *BLANKS and *IN12 = *OFF
     C                                              and *IN03 = *OFF
     C                   EVAL      W1PMD = 'ADD'
     C                   COMMIT
     C                   EXSR      SRReload
     C                   EVAL      *IN12 = *ON
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
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
 
     C     #1SARN        CHAIN     GLGPICL0                           08
 
     C                   IF        *IN08 = *ON
 
      ** Error message if record is missing
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7517'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C                   EXSR      SRScrn2Clr
 
     C                   EVAL      #2SARN = #1SARN
     C                   EVAL      #2DESC = #1DESC
     C                   EVAL      #2IFIL = #1IFIL
     C                   EVAL      #2MIDF = GPMIDF
     C                   EVAL      #2ILIB = GPILIB
     C                   EVAL      #2TFIL = GPTFIL
     C                   EVAL      #2TLIB = GPTLIB
     C                   EVAL      #2IDTQ = GPIDTQ
     C                   EVAL      #2ODTQ = GPODTQ
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      GPWAIT        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        #2WAIT
      *
     C                   EVAL      #2FAIL = GPFAIL
     C                   EVAL      #2CLRF = GPCLRF
     C                   EVAL      #2SPOS = GPSPOS
     C                   EVAL      #2GETP = GPGETP
     C                   EVAL      #2SUSP = GPSUSP
     C                   EVAL      #2INVL = GPINVL
     C                   EVAL      #2PVDT = GPPVDT
     C                   EVAL      #2RPTI = GPRPTI
     C                   EVAL      #2RIAC = GPRIAC
     C                   EVAL      #2UITT = GPUITT
     C                   EVAL      #2UIAC = GPUIAC
     C                   EVAL      #2BLAC = GPBLAC
     C                   EVAL      #2INAC = GPINAC
     C                   EVAL      #2RFAC = GPRFAC
     C                   EVAL      #2BKAC = GPBKAC
     C                   EVAL      #2NSF  = GPNSF
     C                   EVAL      #2CQST = GPCQST
     C                   EVAL      #2CQRG = GPCQRG
     C                   EVAL      #2CQPR = GPCQPR
     C                   EVAL      #2CQNX = GPCQNX
      ** Set the Error Indicator
      *
     C                   EVAL      *IN14 = *OFF
     C                   EVAL      *IN15 = *OFF
     C                   EVAL      *IN16 = *OFF
     C                   EVAL      *IN17 = *OFF
     C                   EVAL      *IN18 = *OFF
     C                   EVAL      *IN19 = *OFF
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
      *
      ** Reset field error indicators
      *
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
      *
     C                   EVAL      W2RSF = 'N'
      ** Reset field error indicators.
     C                   MOVEA     '000000000000'*IN(43)
     C                   MOVEA     '0000'        *IN(56)
     C                   MOVEA     '00'          *IN(60)
     C                   MOVEA     '000000'      *IN(64)
     C                   MOVEA     '000'         *IN(28)
     C                   MOVE      '0'           *IN26
     C                   MOVE      '0'           *IN77
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN38 = *ON
     C                   ENDIF
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF and
     C                             W2RSF = 'N'
     C                   WRITE     SD000123C2
     C                   WRITE     SD000123F1
     C                   EXFMT     SD000123D2
     C                   IF        *IN03 = *OFF and *IN12 = *OFF
     C                   EVAL      W2RSF = 'Y'
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
     C                   EVAL      W1RSF = 'N'
     C                   IF        PMODE = 'E'
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
     C                   MOVEA     '0000'        *IN(43)
     C                   EVAL      *IN55 = *ON
     C                   EVAL      *IN76 = *ON
 
     C                   IF        *IN09 = *ON
     C                   EXSR      SRScrn2Clr
     C                   EVAL      #2SARN = #1SARN
     C                   EVAL      #2DESC = #1DESC
     C                   EVAL      #2IFIL = #1IFIL
     C                   ENDIF
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF and
     C                             W1RSF = 'N'
     C                   WRITE     SD000123C2
     C                   WRITE     SD000123F1
     C                   EXFMT     SD000123D2
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      W#EROR2 = 'N'
      ** Reset field error indicators.
     C                   MOVEA     '000000000000'*IN(43)
     C                   MOVEA     '0000'        *IN(56)
     C                   MOVEA     '00'          *IN(60)
     C                   MOVEA     '000000'      *IN(64)
     C                   MOVEA     '000'         *IN(28)
     C                   MOVE      '0'           *IN26
     C                   MOVE      '0'           *IN77
 
      ** If Exit not pressed, validate Input Screen 2
 
     C                   IF        *IN03 = *OFF and *IN12 = *OFF and
     C                             *IN05 = *OFF
     C                   EXSR      SRScrn2v
     C                   ENDIF
 
      ** If Refresh and Add action, clear fields
 
     C                   IF        *IN05 = *ON and *IN09 = *ON
     C                   EXSR      SRScrn2Clr
     C                   EVAL      #2SARN = #1SARN
     C                   EVAL      #2DESC = #1DESC
     C                   EVAL      #2IFIL = #1IFIL
     C                   ENDIF
 
      ** If Refresh and Amend action, restore original contents
 
     C                   IF        *IN05 = *ON and #1ACTN = 'A'
     C                   EVAL      #2MIDF = P2MIDF
     C                   EVAL      #2IFIL = P2IFIL
     C                   EVAL      #2ILIB = P2ILIB
     C                   EVAL      #2TFIL = P2TFIL
     C                   EVAL      #2TLIB = P2TLIB
     C                   EVAL      #2IDTQ = P2IDTQ
     C                   EVAL      #2ODTQ = P2ODTQ
     C                   EVAL      #2WAIT = P2WAIT
     C                   EVAL      #2FAIL = P2FAIL
     C                   EVAL      #2CLRF = P2CLRF
     C                   EVAL      #2SPOS = P2SPOS
     C                   EVAL      #2GETP = P2GETP
     C                   EVAL      #2SUSP = P2SUSP
     C                   EVAL      #2INVL = P2INVL
     C                   EVAL      #2PVDT = P2PVDT
     C                   EVAL      #2RPTI = P2RPTI
     C                   EVAL      #2RIAC = P2RIAC
     C                   EVAL      #2UITT = P2UITT
     C                   EVAL      #2UIAC = P2UIAC
     C                   EVAL      #2BLAC = P2BLAC
     C                   EVAL      #2INAC = P2INAC
     C                   EVAL      #2RFAC = P2RFAC
     C                   EVAL      #2BKAC = P2BKAC
     C                   EVAL      #2NSF  = P2NSF
     C                   EVAL      #2CQST = P2CQST
     C                   EVAL      #2CQRG = P2CQRG
     C                   EVAL      #2CQPR = P2CQPR
     C                   EVAL      #2CQNX = P2CQNX
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'CHG'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
     C                   IF        W#EROR2 = 'N' and *IN05 = *OFF and
     C                             *IN12 = *OFF and *IN03 = *OFF
     C                   EVAL      W1PMD = 'CHG'
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      WKIPIN = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'CHG'
     C                   EVAL      #1SARN = *BLANKS
     C                   EVAL      #1IFIL = *BLANKS
     C                   ENDIF
     C                   EVAL      *IN55 = *OFF
     C                   EVAL      *IN76 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2Clr - Clear fields for input in Second screen          *
      *                                                               *
      *****************************************************************
     C     SRScrn2Clr    BEGSR
 
     C                   EVAL      #2MIDF = *BLANKS
     C                   EVAL      #2ILIB = *BLANKS
     C                   EVAL      #2TFIL = *BLANKS
     C                   EVAL      #2TLIB = *BLANKS
     C                   EVAL      #2IDTQ = *BLANKS
     C                   EVAL      #2ODTQ = *BLANKS
     C                   EVAL      #2WAIT = *BLANKS
     C                   EVAL      #2FAIL = *BLANKS
     C                   EVAL      #2CLRF = *BLANKS
     C                   EVAL      #2SPOS = *BLANKS
     C                   EVAL      #2GETP = *BLANKS
     C                   EVAL      #2SUSP = *BLANKS
     C                   EVAL      #2INVL = *BLANKS
     C                   EVAL      #2PVDT = *BLANKS
     C                   EVAL      #2RPTI = *BLANKS
     C                   EVAL      #2RIAC = *BLANKS
     C                   EVAL      #2UITT = *BLANKS
     C                   EVAL      #2UIAC = *BLANKS
     C                   EVAL      #2BLAC = *BLANKS
     C                   EVAL      #2INAC = *BLANKS
     C                   EVAL      #2RFAC = *BLANKS
     C                   EVAL      #2BKAC = *BLANKS
     C                   EVAL      #2NSF  = *BLANKS
     C                   EVAL      #2CQST = *BLANKS
     C                   EVAL      #2CQPR = *BLANKS
     C                   EVAL      #2CQRG = *BLANKS
     C                   EVAL      #2CQNX = *BLANKS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2v - Validate input in Second screen                    *
      *                                                               *
      *****************************************************************
     C     SRScrn2v      BEGSR
      *
      ** Midas Feature Flag must be 'Y' or 'N'
 
     C                   IF        #2MIDF <> 'Y' and #2MIDF <> 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0161'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Interface Description must be specified
 
     C                   IF        #2DESC = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN45 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0162'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Interface File Name must be specified if Incoming Data Queue name
      ** not specified
     C                   IF        #2IFIL = *BLANKS
     C                             AND #2IDTQ = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0163'
     C                   EXSR      SRZasnms
      **
     C                   ELSE
      ** Must be no embedded blanks in the filename
     C                   MOVEA     #2IFIL        AFLD10
     C                   Z-ADD     1             X                 2 0
     C                   MOVE      ' '           BLK               1
     C                   MOVE      ' '           ERR               1
     C     X             DOUEQ     11
      *
     C     AFLD10(X)     IFNE      ' '
     C     BLK           ANDEQ     'Y'
     C                   MOVE      'Y'           ERR
     C                   ENDIF
      *
     C     AFLD10(X)     IFEQ      ' '
     C                   MOVE      'Y'           BLK
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   IF        ERR = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0164'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDIF
 
      ** Interface File Library must be specified if Incoming Interface File
      ** specified
     C                   IF        #2ILIB = *BLANKS
     C                             AND #2IFIL <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN47 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0165'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Interface File Library must not be specified if Incoming Interface File
      ** not specified
     C                   IF        #2ILIB <> *BLANKS
     C                             AND #2IFIL = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN47 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0166'
     C                   EXSR      SRZasnms
      *
     C                   ELSE
      ** Must be no embedded blanks in the library
     C                   MOVEA     #2ILIB        AFLD10
     C                   Z-ADD     1             X                 2 0
     C                   MOVE      ' '           BLK               1
     C                   MOVE      ' '           ERR               1
     C     X             DOUEQ     11
      *
     C     AFLD10(X)     IFNE      ' '
     C     BLK           ANDEQ     'Y'
     C                   MOVE      'Y'           ERR
     C                   ENDIF
      *
     C     AFLD10(X)     IFEQ      ' '
     C                   MOVE      'Y'           BLK
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   IF        ERR = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN47 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0167'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
      *
      ** Interface Control File may only be specified if Incoming Interface File
      ** specified
     C                   IF        #2TFIL <> *BLANKS
     C                             AND #2IFIL = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN48 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0168'
     C                   EXSR      SRZasnms
     C                   ELSE
      ** Must be no embedded blanks in the filename
     C                   MOVEA     #2TFIL        AFLD10
     C                   Z-ADD     1             X                 2 0
     C                   MOVE      ' '           BLK               1
     C                   MOVE      ' '           ERR               1
     C     X             DOUEQ     11
      *
     C     AFLD10(X)     IFNE      ' '
     C     BLK           ANDEQ     'Y'
     C                   MOVE      'Y'           ERR
     C                   ENDIF
      *
     C     AFLD10(X)     IFEQ      ' '
     C                   MOVE      'Y'           BLK
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   IF        ERR = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN48 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0164'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
      *
      ** Interface Control File Library must be specified if Interface Control File
      ** specified
     C                   IF        #2TLIB = *BLANKS
     C                             AND #2TFIL <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN49 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0169'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Interface Control File Library must not be specified if Interface Control File
      ** not specified
     C                   IF        #2TLIB <> *BLANKS
     C                             AND #2TFIL = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN49 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0173'
     C                   EXSR      SRZasnms
     C                   ELSE
      ** Must be no embedded blanks in the filename
     C                   MOVEA     #2TLIB        AFLD10
     C                   Z-ADD     1             X                 2 0
     C                   MOVE      ' '           BLK               1
     C                   MOVE      ' '           ERR               1
     C     X             DOUEQ     11
      *
     C     AFLD10(X)     IFNE      ' '
     C     BLK           ANDEQ     'Y'
     C                   MOVE      'Y'           ERR
     C                   ENDIF
      *
     C     AFLD10(X)     IFEQ      ' '
     C                   MOVE      'Y'           BLK
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   IF        ERR = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN49 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0167'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
      *
      ** Incoming Data Queue Name may not be specified if Interface File
      ** specified
     C                   IF        #2IDTQ <> *BLANKS
     C                             AND #2IFIL <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN50 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0170'
     C                   EXSR      SRZasnms
     C                   ELSE
      ** Must be no embedded blanks in the name
     C                   MOVEA     #2IDTQ        AFLD10
     C                   Z-ADD     1             X                 2 0
     C                   MOVE      ' '           BLK               1
     C                   MOVE      ' '           ERR               1
     C     X             DOUEQ     11
      *
     C     AFLD10(X)     IFNE      ' '
     C     BLK           ANDEQ     'Y'
     C                   MOVE      'Y'           ERR
     C                   ENDIF
      *
     C     AFLD10(X)     IFEQ      ' '
     C                   MOVE      'Y'           BLK
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   IF        ERR = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN50 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0171'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
      *
      ** Outgoing Data Queue Name may not be specified if Interface File
      ** specified
     C                   IF        #2ODTQ <> *BLANKS
     C                             AND #2IFIL <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN51 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0172'
     C                   EXSR      SRZasnms
     C                   ELSE
      ** Must be no embedded blanks in the name
     C                   MOVEA     #2ODTQ        AFLD10
     C                   Z-ADD     1             X                 2 0
     C                   MOVE      ' '           BLK               1
     C                   MOVE      ' '           ERR               1
     C     X             DOUEQ     11
      *
     C     AFLD10(X)     IFNE      ' '
     C     BLK           ANDEQ     'Y'
     C                   MOVE      'Y'           ERR
     C                   ENDIF
      *
     C     AFLD10(X)     IFEQ      ' '
     C                   MOVE      'Y'           BLK
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   IF        ERR = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN51 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0171'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
      *
      ** Wait time must be a value between 0 and 99999
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #2WAIT        ZFIELD
     C                   CALL      'ZALIGN'
     C                   PARM                    ZRTN
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      5             ZADIG
     C                   PARM                    ZAFLD
      *
     C                   IF        ZRTN <> *BLANKS
     C                             OR #2WAIT = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN52 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0174'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Fail COB Flag must be 'Y' or 'N'
 
     C                   IF        #2FAIL <> 'Y' and #2FAIL <> 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN54 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0175'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Clear Interface File  must be 'Y' or 'N'
 
     C                   IF        #2CLRF <> 'Y' and #2CLRF <> 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN56 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0176'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Post Invalid Retail Account to suspense must be 'Y' or 'N'
 
     C                   IF        #2SUSP <> 'Y' and #2SUSP <> 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN58 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0177'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Fail COB if invalid items must be 'Y' or 'N'
 
     C                   IF        #2INVL <> 'Y' and #2INVL <> 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN59 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0178'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Post on Value Date must be 'Y' or 'N'
 
     C                   IF        #2PVDT <> 'Y' and #2PVDT <> 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN60 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0179'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Produce Report of Incoming Items must be 'Y' or 'N'
 
     C                   IF        #2RPTI <> 'Y' and #2RPTI <> 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN61 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0180'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Rejected Items Account Code must be a valid account code
 
     C                   MOVEL     #2RIAC        WACOD             1
     C                   IF        #2RIAC <> *BLANKS
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #2RIAC        PACOD
     C     SDACOD        PARM      SDACOD        DSSDY
 
     C                   IF        (PRTCD <> *BLANKS)
     C                             OR (PRTCD = *BLANKS AND A5TOIN = 'Y')
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN30 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0181'
     C                   EXSR      SRZasnms
     C                   ELSE
     C*
     C     WACOD         IFEQ      '?'
     C                   MOVE      A5ACCD        #2RIAC
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
 
      ** Unpaid Items Transaction Type must be a valid transaction type
 
     C                   IF        #2UITT <> *BLANKS
     C                   CALL      'AOTRNTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      #2UITT        PPFTC             5
     C                   PARM      SDTRNT        DSFDY
 
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN63 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0183'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Unpaid Items Account Code must be a valid account code
      ** and must be specified if Transaction Type is specified
     C                   IF        #2UIAC <> *BLANKS
     C                   IF        #2UITT = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN64 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0184'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   MOVEL     #2UIAC        WACOD             1
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #2UIAC        PACOD
     C     SDACOD        PARM      SDACOD        DSSDY
 
     C                   IF        (PRTCD <> *BLANKS)
     C                             OR (PRTCD = *BLANKS AND A5TOIN = 'Y')
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN64 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0182'
     C                   EXSR      SRZasnms
     C                   ELSE
     C*
     C     WACOD         IFEQ      '?'
     C                   MOVE      A5ACCD        #2UIAC
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #2UIAC = *BLANKS
     C                             AND #2UITT <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN64 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0185'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Blocked must be 'R' or 'S' or *Blanks
 
     C                   IF        #2BLAC <> 'R' and #2BLAC <> 'S'
     C                             and #2BLAC <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN65 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0186'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Inactive must be 'R' or 'S' or *Blanks
 
     C                   IF        #2INAC <> 'R' and #2INAC <> 'S'
     C                             and #2INAC <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN66 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0187'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Refer Dr / Cr must be 'R' or 'S' or *Blanks
 
     C                   IF        #2RFAC <> 'R' and #2RFAC <> 'S'
     C                             and #2RFAC <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN67 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0188'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Bankrupt must be 'R' or 'S' or *Blanks
 
     C                   IF        #2BKAC <> 'R' and #2BKAC <> 'S'
     C                             and #2BKAC <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN68 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0189'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Insufficient Funds must be 'R' or 'S' or *Blanks
 
     C                   IF        #2NSF <> 'R' and #2NSF <> 'S'
     C                             and #2NSF <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN69 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0190'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Stopped Cheque must be 'R' or 'S' or *Blanks
 
     C                   IF        #2CQST <> 'R' and #2CQST <> 'S'
     C                             and #2CQST <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN26 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0191'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Cheque Out of Range must be 'R' or 'S' or *Blanks
 
     C                   IF        #2CQRG <> 'R' and #2CQRG <> 'S'
     C                             and #2CQRG <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0192'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Cheque Presented must be 'R' or 'S' or *Blanks
 
     C                   IF        #2CQPR <> 'R' and #2CQPR <> 'S'
     C                             and #2CQPR <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN29 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0193'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Cheque Expected for Account must be 'R' or 'S' or *Blanks
 
     C                   IF        #2CQNX <> 'R' and #2CQNX <> 'S'
     C                             and #2CQNX <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN77 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'SDM0195'
     C                   EXSR      SRZasnms
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
 
     C                   EVAL      #1SARN = *BLANKS
     C                   EVAL      #1DESC = *BLANKS
     C                   EVAL      #1IFIL = *BLANKS
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF
     C                             and W1RSF = 'N'
     C                   WRITE     SD000123C2
     C                   WRITE     SD000123F1
     C                   EXFMT     SD000123D1
 
      ** Clear messages from program message queue
      ** and reset work fields
 
     C                   CALL      'ZA0250'
     C                   EVAL      W#EROR = *BLANKS
     C                   MOVEA     '000'         *IN(40)
 
      ** If Exit not pressed, validate Input Screen 1 fields first
      ** before displaying the second Input screen
 
     C                   IF        *IN03 = *OFF and *IN12 = *OFF
 
      ** Unique Interface Reference is Mandatory
 
     C                   IF        #1SARN = *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'SDM0160'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Check if Unique Interface Reference is already existing on file
 
     C                   IF        W#EROR = *Blanks
     C     #1SARN        CHAIN     GLGPICL0                           10
     C                   IF        *IN10 = *OFF
     C                   MOVEA     '0'           *IN(40)
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'SDM0194'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        W#EROR = *Blanks and
     C                             *IN12 = *OFF and *IN03 = *OFF
     C                   EXSR      SRScrn2
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
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
 
      ** Delete Country of Tax Details
 
     C                   EXSR      SRDelete
 
     C                   IF        W#EROR <> *BLANKS
 
      ** Delete unsuccessful
 
     C                   MOVEA     '1111'        *IN(32)
     C                   MOVEA     '11'          *IN(83)
     C                   EXSR      SRMove
     C                   ELSE
 
      ** Blank out record and protect from entry
 
     C                   COMMIT
     C                   EXSR      SRClrScrn
     C                   EVAL      *IN84 = *OFF
 
      ** Reload subfile
 
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      #1POS1 = *Blanks
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
 
      ** Amend Interface File Details
 
     C                   EXSR      SRAmend
 
     C                   IF        W#EROR <> *BLANKS or *IN03 = *ON or
     C                             *IN12 = *ON
     C                   MOVEA     '1111'        *IN(32)
     C                   MOVEA     '11'          *IN(83)
 
      ** Reset subfile record if changed record
 
     C                   EXSR      SRMove
     C                   ELSE
 
      ** Enable entry
 
     C                   EVAL      *IN84 = *OFF
     C                   COMMIT
     C                   ENDIF
 
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
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProtect - Set Display Attributes for Subfile Record         *
      *                                                               *
      *****************************************************************
     C     SRProtect     BEGSR
 
     C                   IF        W1PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
 
      ** Protect keys if change mode or updated record
 
     C                   IF        *IN89 = *ON
     C                   EVAL      *IN79 = *ON
     C                   ENDIF
 
     C                   IF        W1PMD = 'CHG'
     C                   EVAL      *IN78 = *ON
     C                   ENDIF
 
      ** Protect fields during Selection Mode
 
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
     C                   EVAL      #1SARN = *BLANKS
     C                   EVAL      #1DESC = *BLANKS
     C                   EVAL      #1IFIL = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Transfer Records from GLGPICL2 to Subfile            *
      *                                                               *
      *****************************************************************
     C     SRMove        BEGSR
 
      ** Move GLGPICL0 fields to subfile
 
     C                   EVAL      #1SARN = GPSARN
     C                   EVAL      #1DESC = GPDESC
     C                   EVAL      #1IFIL = GPIFIL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Interface Control File Record                *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
 
     C                   EVAL      W#EROR = *BLANKS
 
      ** Create Interface Control File Record
 
     C                   EVAL      GPSARN = #2SARN
     C                   EVAL      GPDESC = #2DESC
     C                   EVAL      GPIFIL = #2IFIL
     C                   EVAL      GPMIDF = #2MIDF
     C                   EVAL      GPILIB = #2ILIB
     C                   EVAL      GPTFIL = #2TFIL
     C                   EVAL      GPTLIB = #2TLIB
     C                   EVAL      GPIDTQ = #2IDTQ
     C                   EVAL      GPODTQ = #2ODTQ
     C                   IF        #2WAIT <> *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #2WAIT        ZFIELD
     C                   CALL      'ZALIGN'
     C                   PARM                    ZRTN
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      5             ZADIG
     C                   PARM                    ZAFLD
     C                   MOVE      ZAFLD         GPWAIT
     C                   ELSE
     C                   Z-ADD     0             GPWAIT
     C                   ENDIF
     C                   EVAL      GPFAIL = #2FAIL
     C                   EVAL      GPCLRF = #2CLRF
     C                   EVAL      GPSPOS = #2SPOS
     C                   EVAL      GPGETP = #2GETP
     C                   EVAL      GPSUSP = #2SUSP
     C                   EVAL      GPINVL = #2INVL
     C                   EVAL      GPPVDT = #2PVDT
     C                   EVAL      GPRPTI = #2RPTI
     C                   EVAL      GPRIAC = #2RIAC
     C                   EVAL      GPUITT = #2UITT
     C                   EVAL      GPUIAC = #2UIAC
     C                   EVAL      GPBLAC = #2BLAC
     C                   EVAL      GPINAC = #2INAC
     C                   EVAL      GPRFAC = #2RFAC
     C                   EVAL      GPBKAC = #2BKAC
     C                   EVAL      GPNSF  = #2NSF
     C                   EVAL      GPCQST = #2CQST
     C                   EVAL      GPCQRG = #2CQRG
     C                   EVAL      GPCQPR = #2CQPR
     C                   EVAL      GPCQNX = #2CQNX
 
      ** Check for duplicate primary key
 
     C     #2SARN        SETLL     @GPICL0                                60
 
     C                   IF        *IN60 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0017'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C                   WRITE     @GPICL0                              61
 
      ** Write error detected
 
     C                   IF        *IN61 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      *IN03 = *ON
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete Interface Control File Record               *
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
 
     C     #1SARN        CHAIN     GLGPICL0                           63
 
      ** Record already deleted
 
     C                   IF        *IN63 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7602'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C                   DELETE    GLGPICL0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend  - Update Interface Control File Record               *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
 
      ** Change Interface Control File Record
 
     C                   EVAL      W#EROR = *BLANKS
 
     C                   EXSR      SRScrn2Clr
 
     C     #1SARN        CHAIN     @GPICL0                            63
 
      ** Record not found
 
     C                   IF        *IN63 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Move to display file fields
 
     C                   EVAL      #2SARN = GPSARN
     C                   EVAL      #2DESC = GPDESC
     C                   EVAL      #2IFIL = GPIFIL
     C                   EVAL      #2MIDF = GPMIDF
     C                   EVAL      #2ILIB = GPILIB
     C                   EVAL      #2TFIL = GPTFIL
     C                   EVAL      #2TLIB = GPTLIB
     C                   EVAL      #2IDTQ = GPIDTQ
     C                   EVAL      #2ODTQ = GPODTQ
      *
     C                   MOVE      GPWAIT        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        #2WAIT
      *
     C                   EVAL      #2FAIL = GPFAIL
     C                   EVAL      #2CLRF = GPCLRF
     C                   EVAL      #2SPOS = GPSPOS
     C                   EVAL      #2GETP = GPGETP
     C                   EVAL      #2SUSP = GPSUSP
     C                   EVAL      #2INVL = GPINVL
     C                   EVAL      #2PVDT = GPPVDT
     C                   EVAL      #2RPTI = GPRPTI
     C                   EVAL      #2RIAC = GPRIAC
     C                   EVAL      #2UITT = GPUITT
     C                   EVAL      #2UIAC = GPUIAC
     C                   EVAL      #2BLAC = GPBLAC
     C                   EVAL      #2INAC = GPINAC
     C                   EVAL      #2RFAC = GPRFAC
     C                   EVAL      #2BKAC = GPBKAC
     C                   EVAL      #2NSF  = GPNSF
     C                   EVAL      #2CQST = GPCQST
     C                   EVAL      #2CQRG = GPCQRG
     C                   EVAL      #2CQPR = GPCQPR
     C                   EVAL      #2CQNX = GPCQNX
 
      ** Put original contents aside in case of Refresh action
     C                   EVAL      P2SARN = #2SARN
     C                   EVAL      P2DESC = #2DESC
     C                   EVAL      P2IFIL = #2IFIL
     C                   EVAL      P2MIDF = #2MIDF
     C                   EVAL      P2ILIB = #2ILIB
     C                   EVAL      P2TFIL = #2TFIL
     C                   EVAL      P2TLIB = #2TLIB
     C                   EVAL      P2IDTQ = #2IDTQ
     C                   EVAL      P2ODTQ = #2ODTQ
     C                   EVAL      P2WAIT = #2WAIT
     C                   EVAL      P2FAIL = #2FAIL
     C                   EVAL      P2CLRF = #2CLRF
     C                   EVAL      P2SPOS = #2SPOS
     C                   EVAL      P2GETP = #2GETP
     C                   EVAL      P2SUSP = #2SUSP
     C                   EVAL      P2INVL = #2INVL
     C                   EVAL      P2PVDT = #2PVDT
     C                   EVAL      P2RPTI = #2RPTI
     C                   EVAL      P2RIAC = #2RIAC
     C                   EVAL      P2UITT = #2UITT
     C                   EVAL      P2UIAC = #2UIAC
     C                   EVAL      P2BLAC = #2BLAC
     C                   EVAL      P2INAC = #2INAC
     C                   EVAL      P2RFAC = #2RFAC
     C                   EVAL      P2BKAC = #2BKAC
     C                   EVAL      P2NSF  = #2NSF
     C                   EVAL      P2CQST = #2CQST
     C                   EVAL      P2CQRG = #2CQRG
     C                   EVAL      P2CQPR = #2CQPR
     C                   EVAL      P2CQNX = #2CQNX
 
      ** Check if code already existing on file
 
     C                   EXSR      SRScrn2
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
      ** Set record data changed flag
 
     C                   EVAL      WCTRT = 'N'
 
     C                   IF        W#EROR = *Blanks and *IN12 <> *ON and
     C                             *IN03 <> *ON
     C     #1SARN        CHAIN     @GPICL0                            63
 
      ** Record not found
 
     C                   IF        *IN63 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Populate file fields.
     C                   EVAL      GPDESC = #2DESC
     C                   EVAL      GPIFIL = #2IFIL
     C                   EVAL      GPMIDF = #2MIDF
     C                   EVAL      GPILIB = #2ILIB
     C                   EVAL      GPTFIL = #2TFIL
     C                   EVAL      GPTLIB = #2TLIB
     C                   EVAL      GPIDTQ = #2IDTQ
     C                   EVAL      GPODTQ = #2ODTQ
     C                   IF        #2WAIT <> *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #2WAIT        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   CALL      'ZALIGN'
     C                   PARM                    ZRTN
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      5             ZADIG
     C                   PARM                    ZAFLD
     C                   MOVE      ZAFLD         GPWAIT
     C                   ELSE
     C                   Z-ADD     0             GPWAIT
     C                   ENDIF
     C                   EVAL      GPFAIL = #2FAIL
     C                   EVAL      GPCLRF = #2CLRF
     C                   EVAL      GPSPOS = #2SPOS
     C                   EVAL      GPGETP = #2GETP
     C                   EVAL      GPSUSP = #2SUSP
     C                   EVAL      GPINVL = #2INVL
     C                   EVAL      GPPVDT = #2PVDT
     C                   EVAL      GPRPTI = #2RPTI
     C                   EVAL      GPRIAC = #2RIAC
     C                   EVAL      GPUITT = #2UITT
     C                   EVAL      GPUIAC = #2UIAC
     C                   EVAL      GPBLAC = #2BLAC
     C                   EVAL      GPINAC = #2INAC
     C                   EVAL      GPRFAC = #2RFAC
     C                   EVAL      GPBKAC = #2BKAC
     C                   EVAL      GPNSF  = #2NSF
     C                   EVAL      GPCQST = #2CQST
     C                   EVAL      GPCQRG = #2CQRG
     C                   EVAL      GPCQPR = #2CQPR
     C                   EVAL      GPCQNX = #2CQNX
      *
     C                   EVAL      GPLCTP = 'A'
     C                   Z-ADD     BJRDNB        GPLCDT
     C                   UPDATE    @GPICL0
     C                   EVAL      WCTRT = 'Y'
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
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
      * Calls:                                                        *
      * Y2SNMGC  - Retrieve message description and display on screen.*
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SRZasnms      BEGSR
      *
      *
     C     PZPrgmQ       IFEQ      *Blank
     C                   MOVEL(P)  'SD000123'    PZPrgmQ
     C                   ENDIF
      *
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PZPrgmQ                        Program queue
     C                   PARM                    PZRelQ                         Rel queue
     C                   PARM                    PZMsgId                        Message ID
     C                   PARM                    PZMsgFile                      Message file
     C                   PARM                    PZMsgDta                       Message data
     C                   PARM                    PZMsgTyp                       Message type
      *
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        PZRelQ
     C                   MOVEL     *BLANK        PZMsgId
     C                   MOVEL     *BLANK        PZMsgDta
     C                   MOVEL     *BLANK        PZMsgTyp
      *
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
 
      ** Rollback any uncommitted DBF changes
 
     C                   ROLBK                                          60
 
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
 
      ** Define LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD000123'
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
     C                   EVAL      DBPGM  = 'SD000123'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Open files for update
     C                   OPEN      SD000123DF
     C                   IF        #GPIC0 <> '1'
     C                   OPEN      GLGPICL0
     C                   ENDIF
     C                   IF        #GPIC1 <> '1'
     C                   OPEN      GLGPICL2
     C                   ENDIF
 
     C                   Z-ADD     14            WSFPG
 
      ** Set to *CHANGE mode
     C                   EVAL      W1PMD = 'CHG'
 
      ** Initialise subfile control
     C                   EVAL      SPOSN = *BLANKS
     C                   EVAL      #1RUNA = BJMRDT
     C                   EVAL      #1PGMQ = PSProcName
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1USER = PSUser
 
      * Initialise subfile control
     C                   MOVEL     *BLANK        #1POS1
     C                   MOVEL     *BLANK        #1POS2
     C                   MOVEL     *BLANK        #1POS3
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
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
** CPY@
(c) Misys International Banking Systems Ltd. 2014
