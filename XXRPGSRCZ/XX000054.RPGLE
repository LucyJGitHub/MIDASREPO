     H DEBUG DATEDIT(*YMD)
      ********************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Interface File Copy Definition')                       *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas  - Midas Interface.                                    *
      *                                                               *
      ***GLM054*-*Interface*File*Copy*Definition***********************                       LUC109
      *  XX000054 - Interface File Copy Definition                    *                       LUC109
      *  (Copy of IBM003 - CAR ICM003)                                *
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      ***(C)*Copyright*Midas-Kapiti*International*Ltd.*1998************                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. MMI043 *Create     Date 01Dec99               *
      *                 nnnnnn             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MMI043 - Bank of Italy Head Office Reporting                 *
      *                                                               *
      *****************************************************************
      *  Subroutine Index                                             *
      *                                                               *
      *  #IINIT - Initial processing                                  *
      *  #ILDSF - Load subfile                                        *
      *  #ISCRD - Screen display processing                           *
      *  #IEXIT - Exit program                                        *
      *  #IADDR - Add new definition                                  *
      *  #IOPTN - Options processing                                  *
      *  #IAMDR - Amend definition                                    *
      *  #IENQR - Exit program                                        *
      *  #IDELR - Delete definition                                   *
      *  #IVALD - Validate user input                                 *
      *  #IRFSH - Refresh screen                                      *
      *  #IRLUP - Roll up processing                                  *
      *  #ICPYF - Copy file processing                                *
      *  #IEXFM - Display subfile screen                              *
      *  #IMVFF - Move file fields to screen                          *
      *  #IMVFS - Move file fields to subfile                         *
      *  #IMVSC - Move screen fields to file                          *
      *  #IMSGC - Clear message queue                                 *
      *  #ICLRS - Clear subfile                                       *
      *  #ISCCL - Clear subfile fields                                *
      *  ZASNMS - Error messages processing                           *
      *                                                               *
      *****************************************************************
      * Indicator Summary                                             *
      *                                                               *
      *   03 - Exit program                                           *
      *   05 - Refresh screen                                         *
      *   09 - Insert new record                                      *
      *   12 - Previous screen indicator                              *
      *   21 - Protect field in enquiry mode                          *
      *   22 - Protect field in amend and add mode                    *
      *   23 - F12 text display                                       *
      *   24 - F10 text display                                       *
      *   27 - Roll up indicator                                      *
      *   30 - Loop indicator in ENQ mode                             *
      *   32 - Read to IBINCPV0                                       *
      *   33 - Chain to IBINCPV1                                      *
      *   41 - Error on field I1MDFN (Midas filename)                 *
      *   42 - Error on field I1TGFN (Target filename)                *
      *   43 - Error on field/s I1SLC1-7 (Selection criteria)         *
      *   50 - Validation Check (ON if error)                         *
      *   51 - ERRMSGID                                               *
      *   60 - Display subfile                                        *
      *   61 - Display subfile control                                *
      *   62 - End of subfile                                         *
      *   89 - Readc to sflrcd                                        *
      *U7-U8 - General Error Indicators                               *
      * LR - Last Record Indicator                                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     F***GLM054DF  CF   E             WORKSTN                                                 LUC109
     FXX000054DFCF   E             WORKSTN                                                    LUC109
     F                                     SFILE(#SFLRCD:UIRRN)
      ** Interface file copy definition display file.
      *
     F***GLINCPV0  IF   E           K DISK                                                    LUC109
     FXXINCPV0  IF   E           K DISK                                                       LUC109
      ** Interface copy file, keyed on target filename.
      *
     F***GLINCPV1  UF A E           K DISK    COMMIT                                          LUC109
     FXXINCPV1  UF A E           K DISK    COMMIT                                             LUC109
     F                                     RENAME(XXINCPD0:XXINCPU0)                          LUC109
     F**********                           RENAME(GLINCPP0:GLINCPU0)                          LUC109
      ** Interface copy file, keyed on target and Midas filename.
      *
      *****************************************************************
      /SPACE
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement.
      *
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  JOB                  244    253
     D  USER                 254    263
     D LDA           E DS           256    EXTNAME(LDA)
      **  Local data area for data base errors.
      *
     D I1SLCT          DS           512
     D** DS for Selection Criteria field (from screen)
     D  I1SLC1                 1     55
     D  I1SLC2                56    132
     D  I1SLC3               133    209
     D  I1SLC4               210    286
     D  I1SLC5               287    363
     D  I1SLC6               364    440
     D  I1SLC7               441    512
     D*
      *
     D ISLCT           DS
     I** DS for Selection Criteria field.
     I*
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            MAIN     - Control Processing.                     *
      *                                                               *
      * CALLS      #IINIT  -  Initial Processing.                     *
      *            #IINZS  -  Initialise subfile.                     *
      *            #ISCRD  -  Screen Display Processing.              *
      *            #IEXIT  -  Exit program.                           *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing
     C                   EXSR      #IINIT
      *
      ** Initialisation of subfile.
     C                   EXSR      #IINZS
      *
      ** Process screen display and user input.
     C                   EXSR      #ISCRD
      *
      ** End program.
     C                   EXSR      #IEXIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IINIT   - Initial Processing.                     *
      *                                                               *
      *                                                               *
      * CALLED BY         Main Processing                             *
      *                                                               *
      ********************************************************************
     C     #IINIT        BEGSR
      *                                                               *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
     C                   MOVE      PGM           ZAPGM            10
     C                   MOVE      PGM           ##PGM
      *
      ** Define Local Data Area for error handling
     C     *DTAARA       DEFINE                  LDA
      *                                                               *
      ***Define*key*list*to*access*GLINCPV0****************************                       LUC109
      ** Define key list to access XXINCPV0                                                   LUC109
     C     UIKEY         KLIST
     C                   KFLD                    UIMDK            10
     C                   KFLD                    UITGK            10
     C*
      ** Initialise Return code for Midas filename
     C                   Z-ADD     0             UIRTN             1 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IINZS   - Initialise subfile.                     *
      *                                                               *
      * CALLS      ZASNMS   - Error message handling.                 *
      *            #ILDSF   - Load subfile.                           *
      *            #ICLRS   - Clear subfile.                          *
      *                                                               *
      * CALLED BY             Main processing.                        *
      *            #ISCRD   - Screen display processing.              *
      *                                                               *
      ********************************************************************
     C     #IINZS        BEGSR
      *
      ** Initialise subfile page and number of records.
     C                   Z-ADD     12            UISFPG            3 0          SFLPAG
     C                   Z-ADD     1             UISFRN
      *
      ** Initialise relative record number.
     C                   Z-ADD     0             UIRRN             5 0
     C                   Z-ADD     0             UIRNO             5 0
      *
      ** Clear the subfile before reloading
     C                   EXSR      #ICLRS
      *
      ** Set pointer to the top of the file to get the first
      ** database record for the subfile
     C******LOVAL        SETLL     GLINCPV0                                                   LUC109
     C**********         READ      GLINCPV0                               32                  LUC109
     C     *LOVAL        SETLL     XXINCPV0                                                   LUC109
     C                   READ      XXINCPV0                               32                  LUC109
      *
      ** If no records found, display error message:
      ** 'No data to display'.
     C     *IN32         IFEQ      *ON
     C                   MOVEA     '010'         *IN(60)
     C                   MOVEL     'XXX0001'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
      *
      ** Save target file of first record.
     C                   MOVE      IMDFN         UI1STM           10
     C                   MOVE      ITGFN         UI1STT           10
     C                   EXSR      #ILDSF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #ILDSF   - Load the subfile.                       *
      *                                                               *
      * CALLS      #ISCCL - Clear subfile fields.                     *
      *            #IMVFS - Move file fields to subfile.              *
      *                                                               *
      * CALLED BY  #IINZS - Initialise subfile.                       *
      *            #IRFSH - Refresh screen.                           *
      *            #IRLUP - Next page processing.                     *
      *                                                               *
      ********************************************************************
     C     #ILDSF        BEGSR
      *
      ** Start at previous highest record in SFL
     C                   Z-ADD     0             COUNT             5 0
     C                   Z-ADD     UIRRN         UISFRN
      *
      ** Load subfile until a subfile page is filled or the
      ** the end of the file is reached.
     C     *IN32         DOWEQ     *OFF
     C     COUNT         ANDLT     UISFPG
      *
      ** Clear the subfile screen fields before reloading.
     C                   EXSR      #ISCCL
      *
      ** Move the fields from the file to the screen.
     C                   EXSR      #IMVFS
      *
      ** If the relative record number is greater than 0, set ON SFLDSP
      ** indicator.
     C     UIRRN         IFGT      0
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *
      ** Increase the loop counter by 1
     C                   ADD       1             COUNT
     C                   WRITE     #SFLRCD
      *
      ** Add 1 to relative record number.
     C                   ADD       1             UIRRN
      *
      ***Read*file*GLINCPV0*and*continue*loading*the*subfile.**********                       LUC109
     C**********         READ      GLINCPV0                               32                  LUC109
      ** Read file XXINCPV0 and continue loading the subfile.                                 LUC109
     C                   READ      XXINCPV0                               32                  LUC109
     C                   ENDDO
      *
      ** Save last record that has been loaded in the subfile
     C                   MOVE      UIRRN         UIRNO             5 0
      *
      ** If all records have been read, switch off More at SFLEND
     C     *IN32         IFEQ      *ON
     C                   MOVE      *ON           *IN62
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #ISCRD   - Display screen with subfile.            *
      *                                                               *
      * CALLS      #IMSGC   - Clear message queue.                    *
      *            #IEXFM   - Display subfile screen.                 *
      *            #IEXIT   - Exit program.                           *
      *            #IRFSH   - Refresh screen.                         *
      *            #IADDR   - Add a new definition.                   *
      *            #IRLUP   - Roll up request.                        *
      *            #IOPTN   - Options screen.                         *
      *            #IINZS   - Initialise subfile.                     *
      *                                                               *
      * CALLED BY             Main processing.                        *
      *                                                               *
      ********************************************************************
     C     #ISCRD        BEGSR
      *
      ** Display screen until F3 is pressed.
     C     *IN03         DOWEQ     *OFF
      *
      ** Initialise error indicators.
     C                   MOVEA     '0000'        *IN(41)
     C                   MOVE      *OFF          *IN50
     C                   EXSR      #IEXFM
      *
      ** If the subfile is empty, allow only for F3/F9.
     C     *IN32         IFEQ      *ON
     C     UIRNO         ANDEQ     0
     C     *IN09         IFEQ      *ON
     C                   EXSR      #IMSGC
     C                   EXSR      #IADDR
      *
      ** Clear message file for validation error messages.
     C     *IN50         IFEQ      *ON
     C                   EXSR      #IMSGC
     C                   ENDIF
     C*                    EXSR #IINZS
     C                   ENDIF
      *
      ** Otherwise continue normal processing.
     C                   ELSE
      *
      ** Reset 'No more records in file' indicator.
     C                   MOVE      *OFF          *IN51
      *
      ** Clear messages from program message queue
     C                   EXSR      #IMSGC
      *
      ** If F3 has been pressed exit program
     C     *IN03         CASEQ     *ON           #IEXIT
      *
      ** If F5 has been pressed refresh screen
     C     *IN05         CASEQ     *ON           #IRFSH
      *
      ** If F9 has been pressed display screen to add a record.
     C     *IN09         CASEQ     *ON           #IADDR
      *
      ** If Roll-up is pressed, display next subfile page.
     C     *IN27         CASEQ     *ON           #IRLUP
      *
      ** Otherwise process option on record.
     C                   CAS                     #IOPTN
      *
     C                   ENDCS
      *
      ** Clear message file for validation error messages.
     C     *IN50         IFEQ      *ON
     C                   EXSR      #IMSGC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #ISCCL   - Screen subfile fields clear.            *
      *                                                               *
      *                                                               *
      * CALLED BY  #ILDSF   - Load subfile.                           *
      *                                                               *
      ********************************************************************
     C     #ISCCL        BEGSR
      *
     C                   MOVE      *BLANKS       I1MDFN
     C                   MOVE      *BLANKS       I1TGFN
     C                   MOVE      *BLANKS       I1INDY
     C                   MOVE      *BLANKS       I1SLCT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *              #IMSGC - Clear messages from program message     *
      *                       queue.                                  *
      *                                                               *
      *                                                               *
      * Called by    #ISCRD - Screen display.                         *
      *              #IVALD - Validation processing.                  *
      *                                                               *
      *****************************************************************
     C     #IMSGC        BEGSR
      *
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IEXIT   - Exit the program.                       *
      *                                                               *
      *                                                               *
      * CALLED BY            Main processing.
      *            #ISCRD -  Screen display processing.               *
      *                                                               *
      ********************************************************************
     C     #IEXIT        BEGSR
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IRFSH   - Refresh screen.                         *
      *                                                               *
      *                                                               *
      * CALLS      #ICLRS   - Clear subfile.                          *
      *            #ILDSF   - Load subfile.                           *
      *                                                               *
      * CALLED BY  #ISCRD   - Screen display.                         *
      *                                                               *
      ********************************************************************
     C     #IRFSH        BEGSR
      *
      **
     C                   MOVEL     UI1STT        UITGK
     C                   MOVEL     UI1STM        UIMDK
      *
      ** Clear Option field.
     C                   MOVE      *BLANKS       I1SEL
      *
      ** Clear subfile.
     C                   EXSR      #ICLRS
      *
      ** Set file back to the beginning and load the screen from start
     C*****UIKEY         SETLL     GLINCPV0                                                   LUC109
     C**********         READ      GLINCPV0                               32                  LUC109
     C     UIKEY         SETLL     XXINCPV0                                                   LUC109
     C                   READ      XXINCPV0                               32                  LUC109
      *
      ** Reset Relative Record Number to One.
     C                   Z-ADD     1             UIRRN
      *
      ** Build subfile page.
     C                   EXSR      #ILDSF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #ICLRS   - Clear the subfile.                      *
      *                                                               *
      *                                                               *
      * CALLED BY  #IRFSH   - Refresh screen.                         *
      *            #IINZS   - Initialise subfile.                     *
      *                                                               *
      ********************************************************************
     C     #ICLRS        BEGSR
      *
      ** Clear the subfile.
     C                   MOVEA     '000'         *IN(60)
     C                   WRITE     #SFLCTL
     C                   MOVEA     '110'         *IN(60)
      *
      ** Reset Relative Record Number to 1
     C                   Z-ADD     1             UIRRN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IADDR   - Add a new definition.                   *
      *                                                               *
      *                                                               *
      * CALLS      #IVALD - Validate user input.                      *
      *            #IMVSC - Move screen fields to file.               *
      *                                                               *
      * CALLED BY  #ISCRD - Screen display processing.                *
      *                                                               *
      ********************************************************************
     C     #IADDR        BEGSR
      *
      ** Clear fields for ADD screen.
     C                   MOVE      *BLANKS       I1MDFN
     C                   MOVE      *BLANKS       I1TGFN
     C                   MOVE      *BLANKS       I1SLCT
      *
      ** Default Intra-Day Update to 'N'.
     C                   MOVE      'N'           I1INDY
      *
      ** Display second screen to add the data for the new record
      ** intil F12 or F3 is pressed, or a record is successfully
      ** added.
     C     *IN03         DOUEQ     *ON
     C     *IN12         OREQ      *ON
      *
     C                   MOVEA     '011'         *IN(21)
     C                   WRITE     FOOTER
     C                   WRITE     #MSGCTL
     C**********         EXFMT     GLM054F1                                                   LUC109
     C                   EXFMT     XX000054F1                                                 LUC109
      *
      ** Validate user input if F3/F12 are not pressed.
     C     *IN12         IFEQ      *OFF
     C     *IN03         ANDEQ     *OFF
     C                   EXSR      #IVALD
      *
      ** If the user input is valid, write the record to the file
      ** and exit the loop.
     C     *IN50         IFEQ      *OFF
     C                   EXSR      #IMVSC
     C**********         WRITE     GLINCPU0                                                   LUC109
     C                   WRITE     XXINCPU0                                                   LUC109
     C                   COMMIT
      *
      ** Clear fields for ADD screen.
     C                   MOVE      *BLANKS       I1MDFN
     C                   MOVE      *BLANKS       I1TGFN
     C                   MOVE      *BLANKS       I1SLCT
     C                   ENDIF
      *
      ** Otherwise redisplay the second screen with the appropriate
      ** error messages.
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   MOVE      *OFF          *IN12
     C                   EXSR      #IINZS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IOPTN   - Options processing.                     *
      *                                                               *
      *                                                               *
      * CALLS      #IAMDR   - Amend a record.                         *
      *            #IENQR   - Enquire on a record.                    *
      *            #IDELR   - Delete a record.                        *
      *            #ICPYF   - Copy file processing.                   *
      *            ZASNMS   - Error handling processing.              *
      *                                                               *
      * CALLED BY  #ISCRD   - Screen display.                         *
      *                                                               *
      ********************************************************************
     C     #IOPTN        BEGSR
      *
      ** Read changed subfile record
     C                   READC     #SFLRCD                                89
      *
      ** Save option and target filename of changed record.
     C*          *IN89     IFEQ *OFF
     C     *IN89         DOWEQ     *OFF
     C     *IN03         ANDEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
     C                   MOVE      I1SEL         UIOPT             1
     C                   MOVE      I1TGFN        UITGFN           10
      *
     C                   SELECT
      *
      ** If amend option.
     C     UIOPT         WHENEQ    'A'
     C                   EXSR      #IAMDR
      *
      ** If enquire option.
     C     UIOPT         WHENEQ    'E'
     C                   EXSR      #IENQR
      *
      ** If copy option.
     C     UIOPT         WHENEQ    'C'
     C                   EXSR      #ICPYF
      *
      ** If delete record
     C     UIOPT         WHENEQ    'D'
     C                   EXSR      #IDELR
      *
      ** If option is blank give error message:
      ** 'An option must be entered.'
     C     UIOPT         WHENEQ    ' '
     C                   MOVE      *ON           *IN15
     C                   MOVEL     'XXX0028'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
      ** If option is not within valid values, give error message:
      ** 'Invalid option selected.'
     C                   OTHER
     C                   MOVE      *ON           *IN14
     C                   MOVEL     'XXX0040'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
     C                   ENDSL
      *
     C*                    ENDIF
      ** Read changed subfile record
     C                   READC     #SFLRCD                                89
     C                   ENDDO
      *
      ** Refresh the screen when a valid option has been processed
     C     *IN14         IFEQ      *OFF
     C     *IN15         ANDEQ     *OFF
     C                   EXSR      #IRFSH
     C                   ENDIF
      *
      ** Initialise workfields.
     C                   MOVE      *BLANKS       UIOPT
     C                   MOVE      *BLANKS       I1SEL
     C                   MOVE      *BLANKS       UITGFN
      *
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *OFF          *IN12
     C                   MOVEA     '00'          *IN(14)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IAMDR   - Amend a record.                         *
      *                                                               *
      *                                                               *
      * CALLS      #IVALD   - Validate user input.                    *
      *            #IMVFF   - Move file fields to screen.             *
      *            #IMVSC   - Move screen fields to file.             *
      *                                                               *
      * CALLED BY  #IOPTN   - Options processing.                     *
      *                                                               *
      ********************************************************************
      *
     C     #IAMDR        BEGSR
      *
      ** Get data from file for the specified record.
     C                   EXSR      #IMVFF
     C                   MOVE      UITGFN        UITG             10
      *
      ** Display second screen to amend the data for the record
      ** intil F12 or F3 is pressed, or the record is successfully
      ** amended.
     C     *IN12         DOUEQ     *ON
     C     *IN03         OREQ      *ON
     C     *IN13         OREQ      *ON
      *
     C                   MOVEA     '011'         *IN(21)
     C                   WRITE     FOOTER
     C                   WRITE     #MSGCTL
     C**********         EXFMT     GLM054F1                                                   LUC109
     C                   EXFMT     XX000054F1                                                 LUC109
      *
      ** Validate user input if F3/F12 are not pressed.
     C     *IN12         IFEQ      *OFF
     C     *IN03         ANDEQ     *OFF
     C                   EXSR      #IVALD
      *
      ** If the user input is valid update the record in the file
      ** and exit the loop.
     C     *IN50         IFEQ      *OFF
     C*****ITGFN         SETLL     GLINCPV1                                                   LUC109
     C**********         READ      GLINCPV1                               32                  LUC109
     C     ITGFN         SETLL     XXINCPV1                                                   LUC109
     C                   READ      XXINCPV1                               32                  LUC109
     C                   EXSR      #IMVSC
     C**********         UPDATE    GLINCPU0                                                   LUC109
     C                   UPDATE    XXINCPU0                                                   LUC109
     C                   COMMIT
     C                   MOVE      *ON           *IN13
     C                   ENDIF
      *
      ** Otherwise redisplay the second screen with the appropriate
      ** error messagegs.
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Initialise loop indicator (IN13).
     C                   MOVE      *OFF          *IN13
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IENQR   - Enquiry on a record.                    *
      *                                                               *
      *                                                               *
      * CALLS      #IMVFF   - Move file field names to screen.        *
      *                                                               *
      * CALLED BY  #IOPTN   - Options processing.                     *
      *                                                               *
      ********************************************************************
     C     #IENQR        BEGSR
      *
      ** Get data from file for the specified record.
     C                   EXSR      #IMVFF
      *
      ** Display second screen with record details until F12, F3
      ** or Enter is pressed.
     C     *IN03         DOUEQ     *ON
     C     *IN12         OREQ      *ON
     C     *IN30         OREQ      *ON
     C                   MOVEA     '101'         *IN(21)
     C                   WRITE     FOOTER
     C                   WRITE     #MSGCTL
     C**********         EXFMT     GLM054F1                                                   LUC109
     C                   EXFMT     XX000054F1                                                 LUC109
     C                   MOVE      *ON           *IN30
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IDELR   - Delete a record.                        *
      *                                                               *
      *                                                               *
      * CALLS      #IMVFF   - Move file field names to screen.        *
      *            #IINZS   - Initialise subfile.                     *
      *                                                               *
      * CALLED BY  #IOPTN   - Options processing.                     *
      *                                                               *
      ********************************************************************
     C     #IDELR        BEGSR
      *
      ** Set on F10 indicator for footer.
     C                   MOVE      *ON           *IN24
      *
      ** Get data from file for the specified record.
     C                   EXSR      #IMVFF
      *
      ** Display second screen with record details.
     C     *IN03         DOUEQ     *ON
     C     *IN10         OREQ      *ON
     C     *IN12         OREQ      *ON
     C                   MOVEA     '1011'        *IN(21)
     C                   WRITE     FOOTER
     C                   WRITE     #MSGCTL
     C**********         EXFMT     GLM054F1                                                   LUC109
     C                   EXFMT     XX000054F1                                                 LUC109
      *
      ** If F10 is pressed delete record.
     C     *IN10         IFEQ      *ON
     C**********         DELETE    GLINCPU0                                                   LUC109
     C                   DELETE    XXINCPU0                                                   LUC109
     C                   COMMIT
      *
      ** If there are no more records in the file reset RRN
     C******LOVAL        SETLL     GLINCPV0                                                   LUC109
     C**********         READ      GLINCPV0                               32                  LUC109
     C     *LOVAL        SETLL     XXINCPV0                                                   LUC109
     C                   READ      XXINCPV0                               32                  LUC109
     C     *IN32         IFEQ      *ON
     C                   Z-ADD     0             UIRNO
     C                   EXSR      #IINZS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IVALD   - Validate entries of new/amended defn.   *
      *                                                               *
      *                                                               *
      * CALLS      ZASNMS   - Error message processing.               *
      *            #IMSGC   - Clear messages from message queue.      *
      *                                                               *
      * CALLED BY  #IADDR   - Add a new definition.                   *
      *            #IAMDR   - Amend existing definition.              *
      *                                                               *
      ********************************************************************
     C     #IVALD        BEGSR
      *
      ** Default selection criteria to *ALL if it is empty.
     C     I1SLCT        IFEQ      *BLANKS
     C                   MOVEL     '*ALL'        I1SLCT
     C                   ENDIF
      *
      ** Initialise Return code for Midas filename
     C                   Z-ADD     0             UIRTN             1 0
      *
      ** Clear message file for validation error messages.
     C     *IN50         IFEQ      *ON
     C                   EXSR      #IMSGC
     C                   ENDIF
      *
      ** Initialise error indicators.
     C                   MOVEA     '000'         *IN(41)
     C                   MOVE      *OFF          *IN50
      *
     C     I1MDFN        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN41
      *
      ** Error message: 'File name must be entered.'
     C                   MOVEL     'XXX0041'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
      ** Otherwise check that file exists within Midas system
     C                   ELSE
      *
      ** Check if filename is preceded by blanks, give error
      ** message if it is, validate the name otherwise.
     C                   MOVEL     I1MDFN        UIMID1            1
     C     UIMID1        IFEQ      *BLANK
     C                   MOVE      *ON           *IN41
      *
      ** Error message: 'Filename must not be preceded by blanks'
     C                   MOVEL     'XXX0044'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C**********         CALL      'GLCM054'                                                  LUC109
     C                   CALL      'XXC000054'                                                LUC109
     C                   PARM                    I1MDFN
     C                   PARM                    I1SLCT
     C                   PARM                    UIRTN
      *
     C     UIRTN         IFEQ      1
     C                   MOVE      *ON           *IN41
      *
      ** Error message: 'File does not exist within Midas system'
     C                   MOVEL     'XXX0029'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Z-ADD     0             UIRTN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If selection criteria is invalid:
     C     UIRTN         IFEQ      2
     C                   MOVE      *ON           *IN43
      *
      ** Error message: 'Invalid selection criteria'
     C                   MOVEL     'XXX0030'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Z-ADD     0             UIRTN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     I1TGFN        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN42
      *
      ** Error message: 'File name must be entered.'
     C                   MOVEL     'XXX0041'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
      *
      ** If in amend mode and target file name has changed,
      ** perform validation, otherwise ignore.
     C     UIOPT         IFEQ      'A'
     C     UITG          ANDNE     I1TGFN
     C     UIOPT         ORNE      'A'
      *
      ** Check if filename is preceded by blanks, give error
      ** message if it is.
     C                   MOVEL     I1TGFN        UITGT1            1
     C     UITGT1        IFEQ      *BLANK
     C                   MOVE      *ON           *IN42
      *
      ** Error message: 'Filename must not be preceded by blanks'
     C                   MOVEL     'XXX0044'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
      *
      ** Validate filename otherwise.
     C*****I1TGFN        CHAIN     GLINCPV1                           33                      LUC109
     C     I1TGFN        CHAIN     XXINCPV1                           33                      LUC109
     C     *IN33         IFEQ      *OFF
     C                   MOVE      *ON           *IN42
      *
      ** Error message: 'Target filename already exists'.
     C                   MOVEL     'XXX0027'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If any of the fields is invalid set ON error indicator (IN50)
     C     *IN41         IFEQ      *ON
     C     *IN42         OREQ      *ON
     C     *IN43         OREQ      *ON
     C                   MOVE      *ON           *IN50
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IEXFM   - Display subfile screen.                 *
      *                                                               *
      *                                                               *
      * CALLED BY  #ISCRD   - Screen display.                         *
      *                                                               *
      ********************************************************************
     C     #IEXFM        BEGSR
      *
     C                   MOVE      *ON           *IN86
     C                   MOVEA     '00'          *IN(23)
     C                   WRITE     FOOTER
     C                   WRITE     #MSGCTL
     C                   EXFMT     #SFLCTL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IMVFF   - Move file fields to screen.             *
      *                                                               *
      *                                                               *
      * CALLED BY  #IAMDR   - Amend processing.                       *
      *            #IENQR   - Enquire processing.                     *
      *            #IDELR   - Delete processing.                      *
      *                                                               *
      ********************************************************************
     C     #IMVFF        BEGSR
      *
      ** Get data for the specified record.
     C*****UITGFN        SETLL     GLINCPV1                                                   LUC109
     C**********         READ      GLINCPV1                               32                  LUC109
     C     UITGFN        SETLL     XXINCPV1                                                   LUC109
     C                   READ      XXINCPV1                               32                  LUC109
     C                   MOVE      IMDFN         I1MDFN
     C                   MOVE      ITGFN         I1TGFN
     C                   MOVE      IINDY         I1INDY
     C                   MOVE      ISLCT         I1SLCT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IMVFS   - Move file fields to subfile.            *
      *                                                               *
      *                                                               *
      * CALLED BY  #ILDSF   - Screen display.                         *
      *                                                               *
      ********************************************************************
     C     #IMVFS        BEGSR
      *
      ** Get data for the specified record.
     C                   MOVE      IMDFN         I1MDFN
     C                   MOVE      ITGFN         I1TGFN
     C                   MOVE      IINDY         I1INDY
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IMVSC   - Move screen fields to file.             *
      *                                                               *
      *                                                               *
      * CALLED BY  #IADDR   - Insert processing.                      *
      *            #IAMDR   - Amend processing.                       *
      *                                                               *
      ********************************************************************
     C     #IMVSC        BEGSR
      *
     C                   MOVEL     I1MDFN        IMDFN
     C                   MOVEL     I1TGFN        ITGFN
     C                   MOVEL     I1INDY        IINDY
     C                   MOVEL     I1SLCT        ISLCT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #ICPYF   - Copy file to interface library.         *
      *                                                               *
      *                                                               *
      * CALLS      ZASNMS   - Error handling processing.              *
      *                                                               *
      * CALLED BY  #IOPTN   - Options processing.                     *
      *                                                               *
      ********************************************************************
     C     #ICPYF        BEGSR
      *
      ** Initialise Return code for Midas filename
     C                   Z-ADD     0             UIRTN
      *
      ** Get data for the specified record.
     C*****UITGFN        SETLL     GLINCPV1                                                   LUC109
     C**********         READ      GLINCPV1                               32                  LUC109
     C     UITGFN        SETLL     XXINCPV1                                                   LUC109
     C                   READ      XXINCPV1                               32                  LUC109
      *
      ** Call CL pgm that will copy the file.
     C**********         CALL      'GLCM055'                                                  LUC109
     C                   CALL      'XXC000055'                                                LUC109
     C                   PARM                    IMDFN
     C                   PARM                    ITGFN
     C                   PARM                    ISLCT
     C                   PARM                    UIRTN
      *
     C     UIRTN         IFEQ      1
      *
      ** Error message: 'File does not exist within Midas system'
     C                   MOVEL     'XXX0029'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     UIRTN         IFEQ      2
      *
      ** Error message: 'Invalid selection criteria'
     C                   MOVEL     'XXX0030'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     UIRTN         IFEQ      3
      *
      ** Error message: 'Copy from Midas to target file failed.'
     C                   MOVEL     'XXX0042'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IRLUP   - Roll-up request processing.             *
      *                                                               *
      *                                                               *
      * CALLS      #ILDSF -  Load subfile.                            *
      *                                                               *
      * CALLED BY  #ISCRD -  Screen display.                          *
      *                                                               *
      ********************************************************************
     C     #IRLUP        BEGSR
      *
      ** If relative record number is less than highest saved value
      ** restore RRN to highest saved value
     C     UIRRN         IFLT      UIRNO
     C                   MOVE      UIRNO         UIRRN
     C                   ENDIF
      *
      ** Only allow roll up if more records available
     C     *IN32         IFEQ      *ON
     C                   MOVE      *ON           *IN51
     C                   MOVE      *ON           *IN62
     C                   ELSE
      *
      ** Build subfile page.
     C                   EXSR      #ILDSF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZASNMS    - Send program error messages                       *
      *                                                               *
      * Calls                                                         *
      *                                                               *
      * Called by - #IINZS                                            *
      *             #IOPTN                                            *
      *             #IVALD                                            *
      *             #ICPYF                                            *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   ENDIF
      *
      ** If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGM
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2016
