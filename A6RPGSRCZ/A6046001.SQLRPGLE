     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2023')
      ********************************************************************
/*STD *  RPGSQLBND                                                       *
/*EXI *  TEXT('Midas Structured MT940 Mapping Details Mnt 1')            *
      ********************************************************************
      *                                                                  *
      *  Midas  -  Standing Data Module                                  *
      *                                                                  *
      *  A6046001 - Midas Structured MT940 Mapping Maintenance 1         *
      *                                                                  *
      *  (C) Copyright Finastra International Systems Ltd. 2023          *
      *                                                                  *
      *  Last Amend No. BA6026 *CREATE     Date 18Jan23                  *
      *                                                                  *
      ********************************************************************
      *                                                                  *
      *  BA6026 - Structuring Current MT940 and SEPA Compliance.         *
      *           Include GSH046.                                        *
      *                                                                  *
      ********************************************************************
      *  Subroutine Index                                             *
      *                                                               *
      *  #IINIT - Initial processing                                  *
      *  #ILDSF - Load subfile                                        *
      *  #ISCRD - Screen display processing                           *
      *  #IEXIT - Exit program                                        *
      *  #IADDR - Add new definition                                  *
      *  #IOPTN - Options processing                                  *
      *  #IDELR - Delete definition                                   *
      *  #IVALD - Validate user input                                 *
      *  #IRFSH - Refresh screen                                      *
      *  #IRLUP - Roll up processing                                  *
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
      *   23 - F12 text display                                       *
      *   24 - F10 text display                                       *
      *   27 - Roll up indicator                                      *
      *   32 - Read to A6H940L0                                       *
      *   36 - Error on field C1Swid                                  *
      *   37 - Error on field C1Trat                                  *
      *   46 - Error on field S1Sel                                   *
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
     FA6046001DFCF   E             WORKSTN
     F                                     SFILE(#SFLRCD:UIRRN)
      ** Display file
      *
     FA6H940L0  IF   E           K DISK
      ** Structured MT940 Mapping Header - Retrieve
      *
      *****************************************************************
      /SPACE
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement.
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  JOB                  244    253
     D  USER                 254    263
     D LDA           E DS           256    EXTNAME(LDA)
      **  Local data area for data base errors.
      *
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      ** Data structure for SD Retail ICD details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure used for access objects
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure used for access objects
      *
     D WRun            S              1    INZ(*Blanks)
      *
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
      *
      ** Check if SAR GSH046 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'BA6026'      @SARD             6
     C                   PARM                    DSFDY
      *
     C     @RTCD         Ifne      *BLANKS
     C                   Exsr      #IEXIT
     C                   Endif
      *
     C     K2M940        KLIST
     C                   KFld                    K2Swid            4
     C                   KFld                    K2Trat            5
      *
     C     UIM940        KLIST
     C                   KFld                    UISwid            4
     C                   KFld                    UITrat            5
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
      *
     C                   Move      C2Swid        UISwid
     C                   Move      C2Trat        UITrat
      *
     C     C2Swid        Ifeq      *Blanks
     C                   Move      *Loval        UISwid
     C                   Endif
     C     C2Trat        Ifeq      *Blanks
     C                   Move      *Loval        UITrat
     C                   Endif
      *
     C     UIM940        Setll     A6H940L0
     C                   Read      A6H940L0                               33
      *
      ** If no records found, display error message:
      ** 'No data to display'.
     C     *IN33         Ifeq      *ON
     C                   Movea     '010'         *IN(60)
     C                   Movel     'A6X4600'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Else
      *
      ** Save target file of first record.
     C                   Move      HPSWID        UISWID            4
     C                   Move      HPTrat        UITrat            5
     C                   Exsr      #ILDSF
     C                   Endif
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
     C     *IN33         Doweq     *OFF
     C     COUNT         Andlt     UISFPG
      *
      ** Clear the subfile screen fields before reloading.
     C                   Exsr      #ISCCL
      *
      ** Move the fields from the file to the screen.
     C                   Exsr      #IMVFS
      *
      ** If the relative record number is greater than 0, set ON SFLDSP
      ** indicator.
     C     UIRRN         Ifgt      0
     C                   Move      *ON           *IN60
     C                   Endif
      *
      ** Increase the loop counter by 1
     C                   Add       1             COUNT
     C                   Write     #SFLRCD
      *
      ** Add 1 to relative record number.
     C                   Add       1             UIRRN
      *
      ** Read file A6H940TD and continue loading the subfile.
     C                   Read      A6H940L0                               33
     C                   Enddo
      *
      ** Save last record that has been loaded in the subfile
     C                   MOVE      UIRRN         UIRNO             5 0
      *
      ** If all records have been read, switch off More at SFLEND
     C     *IN33         Ifeq      *ON
     C                   Move      *ON           *IN62
     C                   Endif
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
     C     *IN03         Doweq     *OFF
      *
      ** Initialise error indicators.
     C                   Move      *OFF          *IN36
     C                   Move      *OFF          *IN37
     C                   Move      *OFF          *IN46
     C                   Move      *OFF          *IN50
     C                   Exsr      #IEXFM
      *
      ** If the subfile is empty, allow only for F3/F9.
     C     *IN33         Ifeq      *ON
     C     UIRNO         andeq     0
     C     *IN09         Ifeq      *ON
     C                   Exsr      #IMSGC
     C                   Exsr      #IADDR
      *
      ** Clear message file for validation error messages.
     C     *IN50         Ifeq      *ON
     C                   Exsr      #IMSGC
     C                   Endif
     C                   Endif
      *
      ** Otherwise continue normal processing.
     C                   Else
      *
      ** Reset 'No more records in file' indicator.
     C                   Move      *OFF          *IN51
      *
      ** Clear messages from program message queue
     C                   Exsr      #IMSGC
      *
      ** If F3 has been pressed exit program
     C     *IN03         Caseq     *ON           #IEXIT
      *
      ** If F9 has been pressed display screen to add a record.
     C     *IN09         Caseq     *ON           #IADDR
      *
      ** If Roll-up is pressed, display next subfile page.
     C     *IN27         Caseq     *ON           #IRLUP
      *
      ** Otherwise process option on record.
     C                   Cas                     #IOPTN
      *
     C                   Endcs
      *
      ** Clear message file for validation error messages.
     C     *IN50         Ifeq      *ON
     C                   Exsr      #IMSGC
     C                   Endif
      *
     C                   Endif
      *
     C                   Enddo
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
     C                   Move      *Blanks       S1SEL
     C                   Move      *Blanks       S1SWID
     C                   Move      *Blanks       S1Trat
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
     C                   Move      *ON           *INLR
     C                   Return
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
      ** Clear Option field.
     C                   Move      *Blanks       S1SEL
      *
      ** Clear subfile.
     C                   Exsr      #ICLRS
      *
      ** Set file back to the beginning and load the screen from start
      *
     C                   Move      C2Swid        UISwid
     C                   Move      C2Trat        UITrat
      *
     C     C2Swid        Ifeq      *Blanks
     C                   Move      *Loval        UISwid
     C                   Endif
     C     C2Trat        Ifeq      *Blanks
     C                   Move      *Loval        UITrat
     C                   Endif
      *
     C     UIM940        Setll     A6H940L0
     C                   Read      A6H940L0                               33
      *
      ** If no records found, display error message:
      ** 'No data to display'.
     C     *IN33         Ifeq      *ON
     C                   Movea     '010'         *IN(60)
     C                   Movel     'A6X4600'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Else
      *
      ** Reset Relative Record Number to One.
     C                   Z-ADD     1             UIRRN
      *
      ** Build subfile page.
     C                   EXSR      #ILDSF
     C                   Endif
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
     C                   Movea     '000'         *IN(60)
     C                   Write     #SFLCTL
     C                   Movea     '110'         *IN(60)
      *
      ** If no more records in the file, end of subfile
     C     *IN33         Ifeq      *ON
     C                   Movea     '010'         *IN(60)
     C                   Endif
      *
      ** Reset Relative Record Number to 1
     C                   Z-Add     1             UIRRN
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
     C                   Move      *Blanks       C1Swid
     C                   Move      *Blanks       C1Trat
      *
      ** Display second screen to add the data for the new record
      ** until F12 or F3 is pressed, or a record is successfully
      ** added.
     C     *IN03         Doueq     *ON
     C     *IN12         Oreq      *ON
      *
     C                   Movea     '0011'        *IN(20)
     C                   Write     FOOTER
     C                   Write     #MSGCTL
     C                   Exfmt     A6046001F1
      *
      ** Validate user input if F3/F12 are not pressed.
     C     *IN12         Ifeq      *OFF
     C     *IN03         andeq     *OFF
     C                   Exsr      #IVALD
      *
      ** If the user input is valid, write the record to the file
      ** and exit the loop.
     C     *IN50         Ifeq      *OFF
      *
     C                   Call      'A6046002'
     C                   Parm      *Blanks       PRtrn             7
     C                   Parm      C1Swid        PSwid             4
     C                   Parm      C1Trat        PTrat             5
     C                   Parm      'I'           PActn             1
      *
     C     PRtrn         Ifeq      '*Error'
     C                   Movel     '*Call'       DBFILE                         ************
     C                   Movel     '903'         DBASE                          * DBERR 903*
     C                   Movel     'A6046002'    DBKEY                          ************
     C                   Exsr      *PSSR
     C                   Endif
     C     PRtrn         Ifeq      'Y2U9999'
     C                   Move      *On           *IN03
     C                   Endif
      *
      ** Clear fields for ADD screen.
     C                   Move      *Blanks       C1Swid
     C                   Move      *Blanks       C1Trat
     C                   Endif
      *
      ** Otherwise redisplay the second screen with the appropriate
      ** error messages.
     C                   Endif
      *
     C                   Enddo
      *
     C                   Move      *Off          *IN12
     C                   Exsr      #IINZS
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
      * CALLS      #IDELR   - Delete a record.                        *
      *            ZASNMS   - Error handling processing.              *
      *                                                               *
      * CALLED BY  #ISCRD   - Screen display.                         *
      *                                                               *
      ********************************************************************
     C     #IOPTN        BEGSR
      *
      ** Read changed subfile record
     C                   ReadC     #SFLRCD                                89
      *
      ** Save option and target filename of changed record.
     C     *IN89         Doweq     *OFF
     C     *IN03         andeq     *OFF
     C     *IN12         andeq     *OFF
      *
     C                   Move      S1SEL         UIOPT             1
      *
     C                   SELECT
      *
      ** If delete record
     C     UIOPT         Wheneq    'D'
     C                   Exsr      #IDELR
      *
      ** If amend record
     C     UIOPT         Wheneq    'A'
     C                   Exsr      #IAMDR
      *
      ** If enquire record
     C     UIOPT         Wheneq    'E'
     C                   Exsr      #IENQR
      *
      *
      ** If option is not within valid values, give error message:
      ** 'Invalid option selected.'
     C*                  Other
     C     UIOPT         Whenne    ' '
     C     UIOPT         andne     'A'
     C     UIOPT         andne     'E'
     C     UIOPT         andne     'D'
     C                   Move      *ON           *IN14
     C                   Move      *ON           *IN46
     C                   Movel     'A6X4602'     ZAMSID
     C                   Exsr      ZASNMS
      *
     C                   Endsl
      *
      ** Read changed subfile record
     C                   Readc     #SFLRCD                                89
     C                   Enddo
      *
      ** Refresh the screen when a valid option has been processed
     C     *IN14         Ifeq      *OFF
     C     *IN15         andeq     *OFF
     C                   Exsr      #IRFSH
     C                   Endif
      *
      ** Initialise workfields.
     C                   Move      *Blanks       UIOPT
      *
     C                   Move      *Off          *IN12
     C                   Movea     '00'          *IN(14)
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
      *            SEE041   - Maintenance screen 2                    *
      *            #IINZS   - Initialise subfile.                     *
      *                                                               *
      * CALLED BY  #IOPTN   - Options processing.                     *
      *                                                               *
      ********************************************************************
     C     #IDELR        BEGSR
      *
      ** Set on F10 indicator for footer.
     C                   Move      *On           *IN24
      *
     C                   Exsr      #IMSGC
      ** Get data from file for the specified record.
     C                   Move      S1Swid        C1Swid
     C                   Move      S1Trat        C1Trat
      *
      ** Display second screen with record details.
     C     *IN12         Doueq     *On
     C     *IN10         oreq      *On
     C     *IN03         oreq      *On
     C                   Movea     '1011'        *IN(21)
     C                   Write     FOOTER
     C                   Write     #MSGCTL
     C                   Exfmt     A6046001F1
      *
      ** If F10 is pressed delete record.
     C     *IN10         Ifeq      *On

     C/EXEC SQL
     C+ delete from A6M940TD
     C+ where MPSwid = :S1Swid
     C+  and MPTrat = :S1Trat
     C/END-EXEC

     C/EXEC SQL
     C+ delete from A6H940TD
     C+ where HPSwid = :S1Swid
     C+  and HPTrat = :S1Trat
     C/END-EXEC

      ** If there are no more records in the file reset RRN
     C     *Loval        Setll     A6H940L0
     C                   Read      A6H940L0                               33
     C     *IN33         Ifeq      *On
     C                   Z-Add     0             UIRNO
     C                   Exsr      #IINZS
     C                   Endif
      *
     C                   Endif
      *
     C                   Enddo
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
      * CALLS    A6046002   - Maintenance screen 2                    *
      *                                                               *
      * CALLED BY  #IOPTN   - Options processing.                     *
      *                                                               *
      ********************************************************************
     C     #IAMDR        BEGSR
      *
     C                   Call      'A6046002'
     C                   Parm      *Blanks       PRtrn             7
     C                   Parm      S1Swid        PSwid
     C                   Parm      S1Trat        PTrat
     C                   PARM      'A'           PACTN
      *
     C     PRtrn         Ifeq      '*Error'
     C                   Movel     '*Call'       DBFILE                         ************
     C                   Movel     '901'         DBASE                          * DBERR 901*
     C                   Movel     'A6046002'    DBKEY                          ************
     C                   Exsr      *PSSR
     C                   Endif
     C     PRtrn         Ifeq      'Y2U9999'
     C                   Move      *On           *IN03
     C                   Endif
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IENQR   - Enquire a record.                       *
      *                                                               *
      *                                                               *
      * CALLS      SEE041   - Maintenance screen 2                    *
      *                                                               *
      * CALLED BY  #IOPTN   - Options processing.                     *
      *                                                               *
      ********************************************************************
     C     #IENQR        BEGSR
      *
     C                   Call      'A6046002'
     C                   Parm      *Blanks       PRtrn             7
     C                   Parm      S1Swid        PSwid
     C                   Parm      S1Trat        PTrat
     C                   PARM      'E'           PACTN             1
      *
     C     PRtrn         Ifeq      '*Error'
     C                   Movel     '*Call'       DBFILE                         ************
     C                   Movel     '902'         DBASE                          * DBERR 902*
     C                   Movel     'A6046002'    DBKEY                          ************
     C                   Exsr      *PSSR
     C                   Endif
     C     PRtrn         Ifeq      'Y2U9999'
     C                   Move      *On           *IN03
     C                   Endif
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IVALD   - Validate entries of new                 *
      *                                                               *
      *                                                               *
      * CALLS      ZASNMS   - Error message processing.               *
      *            #IMSGC   - Clear messages from message queue.      *
      *                                                               *
      * CALLED BY  #IADDR   - Add a new definition.                   *
      *                                                               *
      ********************************************************************
     C     #IVALD        BEGSR
      *
      ** Initialise error indicators.
     C                   Move      *Off          *IN36
     C                   Move      *Off          *IN37
     C                   Move      *Off          *IN46
     C                   Move      *Off          *IN50
      *
     C                   Move      *Blanks       K2Swid
     C                   Move      *Blanks       K2Trat
      *
      ** Clear message file for validation error messages.
     C     *IN50         Ifeq      *OFF
     C                   Exsr      #IMSGC
     C                   Endif
      *
      ** Check that field has been entered
     C     C1Swid        Ifeq      *Blanks
     C                   Move      *On           *IN50
     C                   Move      *On           *IN36
     C                   Movel     'A6X4603'     ZAMSID
     C                   Exsr      ZASNMS
     C                   else
     C                   Move      C1Swid        K2Swid            4
     C                   Endif
      *
     C     C1Trat        Ifne      *Blanks
     C                   Call      'AORETRR0'
     C                   Parm      *Blanks       @Rtcd             7
     C                   Parm      '*KEY   '     @Optn             7
     C                   Parm      C1Trat        @Tratt            5
     C     SDRetr        Parm      SDRetr        DSFDY

     C     @Rtcd         Ifne      *Blanks
     C                   Move      *On           *In50
     C                   Move      *On           *In37
     C                   Movel     'A6X4604'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Else
     C                   Move      C1Trat        K2Trat
     C                   Endif
     C                   Endif
      *
      ** The field should be unique in A6H940L0
      *
     C     *In50         IFEQ      *OFF
     C     K2M940        Chain     A6H940L0                           34
     C     *IN34         Ifeq      *Off
     C     *IN09         andeq     *On
     C                   Move      *On           *IN50
     C                   Move      *On           *IN36
     C                   Move      *On           *IN37
     C                   Movel     'A6X4605'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
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
      *            #IMVFS   - Move file fields to subfile.            *
      *                                                               *
      *                                                               *
      * CALLED BY  #ILDSF   - Screen display.                         *
      *                                                               *
      ********************************************************************
     C     #IMVFS        BEGSR
      *
      ** Get data for the specified record.
      *
     C                   Move      HPSwid        S1Swid
     C                   Move      HPTrat        S1Trat
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
      *                                                               *
      ********************************************************************
     C     #IMVSC        BEGSR
      *
     C                   Move      K2Swid        HPSwid
     C                   Move      K2Trat        HPTrat
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
     C     *IN33         IFEQ      *ON
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
     C                   MOVEL     'GBSDU'       ZAMSGF
     C                   MOVE      'SRMSG'       ZAMSGF
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
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **

     C                   If        WRun = *BLANKS
     C                   Eval      WRun = 'Y'
     C                   Dump
     C                   Endif

     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
      *
     C                   Return
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(C) Finastra International Systems Ltd. 2023
