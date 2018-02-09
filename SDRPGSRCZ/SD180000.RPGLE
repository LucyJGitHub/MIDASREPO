     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD SWIFT Status and Reason Codes - Select')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD180000 - SWIFT Status and Reason Codes (Selection)         *
      *                                                               *
      *  Function:  This module allows the user to select either a    *
      *             SWIFT Status or Reason code, depending on the     *
      *             value of the input parameter "Code type":         *
      *                                                               *
      *             - S: Selection of a status code (*IN13 on).       *
      *             - R: Selection of a reason code (*IN13 off).      *
      *                                                               *
      *             There are two sub-cases, depending on the value   *
      *             of the parameter "Linked Status Code":            *
      *                                                               *
      *             - If blank: All the existing reason codes will be *
      *                         displayed, and the position field     *
      *                         "Linked Status" will be amendable     *
      *                         (*IN14 on)                            *
      *             - Else: Only the reason codes depending on the    *
      *                     received linked status code will be       *
      *                     displayed and the position field "Linked  *
      *                     Status" will be protected (*IN14 off).    *
      *                                                               *
      *  Parameters list and their returned values:                   *
      *                                                               *
      *   Return code       : .Blank   = Ok, something was selected.  *
      *                       .*FEATUR = CSE039 is off.               *
      *                       .*PARM   = Incorrect input parameter.   *
      *                       .Y2U0016 = No selection done.           *
      *                       .*ERROR  = Unexpected error (*PSSR).    *
      *                                                               *
      *   SWIFT code        : The selected status or reason code.     *
      *                                                               *
      *   Code type         : Input only. R or S (see above).         *
      *                                                               *
      *   Dependency Code   : The value displayed on the selected     *
      *           (Linked status code)  line (blank if code type S).  *
      *                                                               *
      *  Note: The received code type is always treated as the first  *
      *        key positional field, and stored as an hidden field    *
      *        the subfile control format.                            *
      *        The selection on "Narrative" acts as a scan on the     *
      *        corresponding file field.                              *
      *                                                               *
      *  Component of: SD1800000                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE039  *CREATE    Date 28Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
 
     FSDSCODL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDSCODD0:SDSCODD1)
      ** Midas SD SWIFT Status and Reason Codes
      *
 
     FSD180000DFCF   E             WORKSTN SFILE(SD180000S0:S0RRN)
      ** Midas SD SWIFT Status and Reason Codes - Select
      *
 
      *========================================================================*
      * Use of Indicators                                                      *
      *                                                                        *
      * Display Conditioning Indicators                                        *
      *                                                                        *
      * 13 - Display Status Codes if *On / Reason Codes if *Off                *
      * 14 - Key positional field "Linked Status" amendable if *On             *
      *                                                                        *
      * Action key Indicators                                                  *
      *                                                                        *
      * KC - Exit Program                                                      *
      * KE - Refresh Screen                                                    *
      * KI - Insert Mode                                                       *
      * KL - Previous Screen                                                   *
      *                                                                        *
      * Error Indicators                                                       *
      *                                                                        *
      * 40 - General Error Indicator                                           *
      * 41 - Error On Action Code                                              *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved error    *
      *  indicators)                                                           *
      *                                                                        *
      * Subfile Management Indicators                                          *
      *                                                                        *
      * 21 - SFLDSPCTL if *ON / SFLCLR if *OFF                                 *
      * 22 - SFLDSP                                                            *
      * 23 - SFLEND                                                            *
      * 24 - SFLNXTCHG                                                         *
      * 25 - Rollup                                                            *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access SDSCODL1                                                   *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*
 
      *========================================================================*
      ** Automatically included D-specs
      ** ==============================
      *
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      ** Manually included D-specs
      ** =========================
      *
 
      ** Named constants
      ** ---------------
      *
 
      ** Arrays and Data Structures
      ** --------------------------
      *
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *
 
      ** Current selection
      *
     D CurSelect       DS
     D  CurCDTP                            LIKE(C0CDTP)
     D  CurCDDP                            LIKE(C0CDDP)
     D  CurCODE                            LIKE(C0CODE)
     D  CurCDNR                            LIKE(C0CDNR)
 
      ** Displayed selection
      *
     D ScrSelect       DS
     D  C0CDTP
     D  C0CDDP
     D  C0CODE
     D  C0CDNR
 
      ** Effective Selection
      *
     D EffSelect       DS
     D  EffCODE                            LIKE(C0CODE)
     D  EffCDNR                            LIKE(C0CDNR)
 
      ** Really used key
      *
     D KeyUsed         DS
     D  KeyCDTP                            LIKE(SRCDTP)
     D  KeyCDDP                            LIKE(SRCDDP)
     D  KeyCODE                            LIKE(SRCODE)
 
      ** Position key
      *
     D KeyPos          DS
     D  KeyPosCDTP                         LIKE(SRCDTP)
     D  KeyPosCDDP                         LIKE(SRCDDP)
     D  KeyPosCODE                         LIKE(SRCODE)
 
      ** Saved key
      *
     D KeySav          DS
     D  KeySavCDTP                         LIKE(SRCDTP)
     D  KeySavCDDP                         LIKE(SRCDDP)
     D  KeySavCODE                         LIKE(SRCODE)
 
      ** Declared variables
      ** ------------------
      *
 
      ** Error indicators array
      *
     D IN40_TO_70      S              1    DIM(31)
 
      ** Parameters
      *
     D @CODE           S                   LIKE(C0CODE)
     D @CDTP           S                   LIKE(C0CDTP)
     D @CDDP           S                   LIKE(C0CDDP)
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *
 
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    @RtCd
     C                   PARM      S0CODE        @CODE
     C     C0CDTP        PARM                    @CDTP
     C     C0CDDP        PARM      S0CDDP        @CDDP
 
      ** Key lists
      *
     C     KSDSCODL1     KLIST
     C                   KFLD                    KeyCDTP
     C                   KFLD                    KeyCDDP
     C                   KFLD                    KeyCODE
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR SR
 
      ** Initialize the selection criteria
      *
     C                   EXSR      $IniSelect
 
      ** Initialize the subfile
      *
     C                   EXSR      $IniSubFil
 
      ** Load the subfile
      *
     C                   EXSR      $LoadSubfl
 
      ** Main loop (based on F3 indicator)
      *  ---------------------------------
     C                   DOW       NOT *INKC
 
      ** -- Informational message if the subfile is empty
      *
     C  N22              MOVE      'Y2U0008'     ZAMSID
     C  N22              MOVEL (P) 'Y2USRMSG'    ZAMSGF
     C  N22              EXSR      $ZaSndMsg
 
      ** -- Display the screen (error messages, header and subfile)
      *
     C                   WRITE     SD180000H0
     C                   WRITE     #MSGCTL
     C                   EXFMT     SD180000C0
 
      ** -- Clear the error messages subfile
      *
     C                   EXSR      $ClrErrSF
 
      ** -- Action keys management
      *     ----------------------
      ** ---- F3 ==> Exit Module
      *
     C                   IF        *INKC
     C                   MOVE      'Y2U0016'     ZAMSID
     C                   MOVEL (P) 'Y2USRMSG'    ZAMSGF
     C                   MOVEL (P) '*PRV'        ZAPGRL
     C                   EXSR      $ZaSndMsg
     C                   MOVEL (P) 'Y2U0016'     @RtCd
     C                   ITER
     C                   ENDIF
 
      ** ---- F5 ==> Refresh screen: .Restore selection fields
      **                             .Re-load subfile
      *
     C                   IF        *INKE
     C                   MOVEL     CurSelect     ScrSelect
     C                   EXSR      $IniSubFil
     C                   EXSR      $LoadSubfl
     C                   ITER
     C                   ENDIF
 
      ** ---- Roll-Up
      *
     C                   IF        *IN25
 
      ** ------ Restore stored key value and reposition file in order to
      **        continue subfile filling from the right point
      *
     C                   MOVEL     KeyPos        KeyUsed
     C     KSDSCODL1     CHAIN     SDSCODD1                           27
 
      ** ------ Load Subfile
      *
     C                   EXSR      $LoadSubfl
     C                   ITER
     C                   ENDIF
 
      ** -- Selection criteria management
      *     -----------------------------
      ** -- If selection criteria were changed, re-load the subfile
      *     according to the new selection
      *
     C                   IF        ScrSelect <> CurSelect
     C                   EXSR      $IniSelect
     C                   EXSR      $IniSubFil
     C                   EXSR      $LoadSubfl
     C                   ITER
     C                   ENDIF
 
      ** -- Action codes management (If *IN22 is on, the subfile exists)
      *     -----------------------
     C   22              EXSR      $ValActCde
 
      ** ---- If no error process action codes, else redisplay the screen
      *
     C                   IF        ValidCodes = 'Y'  AND *IN22
     C                   EXSR      $PrcActCde
     C                   ELSE
     C                   ITER
     C                   ENDIF
 
     C                   ENDDO
 
      ** End Program
      *
     C                   EXSR      $ExitMod
 
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
 
      *========================================================================*
      * $IniSelect - Initialize selection keys / criteria by screen entries    *
      *------------------------------------------------------------------------*
     C     $IniSelect    BEGSR
      *    ----------    ------
      ** Save entries
      *
     C                   MOVEL     ScrSelect     CurSelect
 
      ** Reset key and effective selection DS's
      *
     C                   CLEAR                   KeyUsed
     C                   CLEAR                   EffSelect
 
      ** Reset fill key flag
      *
     C                   MOVE      'Y'           FillKey           1
 
      ** FillKey = 'Y' ---> Continue with filling 'key used' fields
      ** FillKey = 'N' ---> Continue with filling 'effective selection' fields
 
      **    The method to fill key / selection DS's is as follows :   **
      **                                                              **
      **    Check if every screen field corresponding to a file       **
      **    key field is blank or not. This must be done in the       **
      **    same order as the KLIST.                                  **
      **                                                              **
      **    If the field is filled, move it to the corresponding      **
      **    key list field, and continue to do so until finding a     **
      **    blank key field.                                          **
      **                                                              **
      **    In this case move N to the fill key flag and move the     **
      **    remaining screen fields corresponding to a file key field **
      **    to the corresponding fields of the selection DS.          **
      **                                                              **
      **    When all screen key fields have been processed, continue  **
      **    to fill the selection DS with the screen fields that are  **
      **    only for selection purpose.                               **
 
      ** Code Type (always key field, because it's the first one)
      **    Never blank, as its value is checked in *INZSR
      *
      *    **            IF        C0CDTP <> *Blanks
     C                   MOVEL (P) C0CDTP        KeyCDTP
      *    **            ELSE
      *    **            MOVE      'N'           FillKey
      *    **            ENDIF
 
      ** Dependency Code, i.e. Linked Status Code (key or selection field)
      **    In fact, always key field as the previous one is never blank
      *
     C                   IF        C0CDDP <> *Blanks
     C                   MOVEL     C0CDDP        KeyCDDP
     C                   ELSE
      ** A second key field equal to blank is correct for Status Code Selection
     C                   IF        C0CDTP = 'R'
     C                   MOVE      'N'           FillKey
     C                   ENDIF
      *
     C                   ENDIF
 
      ** Status/Reason Code (key or selection field)
      *
     C                   IF        C0CODE <> *Blanks AND FillKey = 'Y'
     C                   MOVEL     C0CODE        KeyCODE
     C                   ELSE
     C                   MOVEL     C0CODE        EffCODE
     C                   ENDIF
 
      ** Status/reason Narrative (always selection field)
      *
     C                   MOVEL     C0CDNR        EffCDNR
 
      ** Save key values corresponding to selection criteria
      *
     C                   MOVE      KeyUsed       KeySav
      *    ----------    ------
     C     @IniSelect    ENDSR
 
      *========================================================================*
      * $ValActCde: Validate action codes                                      *
      *------------------------------------------------------------------------*
     C     $ValActCde    BEGSR
      *    ----------    ------
      ** Reset valid code flag (Default to 'Y') and RRN
      *
     C                   MOVE      'Y'           ValidCodes        1
     C                   Z-ADD     1             S0RRN
     C                   EVAL      C0RRN = WSavRRN
 
      ** Check if action code is blank or '1'
      *
     C                   READC     SD180000S0                             99
 
     C                   DOW       NOT *IN99
     C                   MOVE      *Off          *IN24
     C                   MOVE      *Off          *IN41
 
      ** -- Only process non blank action codes
      **    (In order to have them processed by the next subroutine, their
      **     Modified Data Tag is reset to ON by using *IN24 - SFLNXTCHG -)
      *
     C                   IF        S0ACTCDE <> *Blanks
     C                   MOVE      *On           *IN24
 
      ** ---- Invalid Action Code
      *
     C                   IF        S0ACTCDE <> '1'
     C                   MOVE      *On           *IN41
     C                   MOVE      'SE03901'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      'N'           ValidCodes
 
      ** ------ The subfile page containing the FIRST error should
      **        be displayed
      *
     C                   IF        C0RRN > S0RRN
     C                   EVAL      C0RRN = S0RRN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   UPDATE    SD180000S0
     C                   READC     SD180000S0                             99
     C                   ENDDO
      *    ----------    ------
     C     @ValActCde    ENDSR
 
      *========================================================================*
      * $PrcActCde: Process action codes                                       *
      *------------------------------------------------------------------------*
     C     $PrcActCde    BEGSR
      *    ----------    ------
      ** Reset RRN and loop on the subfile
      *
     C                   Z-ADD     1             S0RRN
     C                   READC     SD180000S0                             99
 
 B1  C                   DOW       NOT *IN99
     C                   MOVE      *Off          *IN41
     C                   MOVE      *Off          *IN24
 
      ** Process the first selected record
      *
 B2  C                   IF        S0ACTCDE = '1'
     C                   EXSR      $ReturnRcd
 
      ** -- The code may reach this point only if an error occurs
      **    in $ReturnRcd
      *
     C                   MOVE      *On           *IN24
     C                   UPDATE    SD180000S0
     C                   GOTO      @PrcActCde
 E2  C                   ENDIF
 
     C                   READC     SD180000S0                             99
 E1  C                   ENDDO
      *    ----------    ------
     C     @PrcActCde    ENDSR
 
      *========================================================================*
      * $ReturnRcd: Check the first selected record references before          *
      *             returning them to the caller                               *
      *------------------------------------------------------------------------*
     C     $ReturnRcd    BEGSR
      *    ----------    ------
      ** Access the file with the selected record key value
      *
     C                   MOVE      C0CDTP        KeyCDTP
     C                   MOVE      S0CDDP        KeyCDDP
     C                   MOVE      S0CODE        KeyCODE
     C     KSDSCODL1     SETLL     SDSCODD1                               27
 
      ** -- Record Not Found
      *
 B1  C                   IF        NOT *IN27
     C                   MOVE      'SE03904'     ZAMSID
     C                   MOVE      *On           *IN41
     C                   EXSR      $ZaSndMsg
 
      ** -- All's OK, exit the program returning the selected values
      *
 X1  C                   ELSE
     C                   EXSR      $ExitMod
 E1  C                   ENDIF
      *    ----------    ------
     C     @ReturnRcd    ENDSR
 
      *========================================================================*
      * $IniSubFil: Initialise Subfile                                         *
      *------------------------------------------------------------------------*
     C     $IniSubFil    BEGSR
      *    ----------    ------
      ** Clear the subfile
      *
     C                   MOVE      *Off          *IN21
     C                   WRITE     SD180000C0
     C                   MOVE      *On           *IN21
 
      ** Reset the saving field of the subfile line number
      *
     C                   Z-ADD     0             WSavRRN
 
      ** Restore key values corresponding to selection criteria
      *
     C                   MOVE      KeySav        KeyUsed
 
      ** Position within SDSCODL1
      *
     C     KSDSCODL1     SETLL     SDSCODD1
 
      ** First read of SDSCODL1
      *
     C                   READ      SDSCODD1                               27
 
      ** Reset error indicators (40 - 70)
      *
     C                   MOVEA     *Zeros        IN40_TO_70
     C                   MOVEA     IN40_TO_70    *IN(40)
      *    ----------    ------
     C     @IniSubFil    ENDSR
 
      *========================================================================*
      * $LoadSubfl: Load a subfile page                                        *
      *------------------------------------------------------------------------*
     C     $LoadSubfl    BEGSR
      *    ----------    ------
     C                   Z-ADD     WSavRRN       S0RRN             4 0
     C                   Z-ADD     0             WCount            2 0
     C                   MOVE      *Blanks       S0ACTCDE
     C                   MOVE      *Off          *IN41
 
      ** Fill subfile loop - See cases explained in the header box -
      *
 B1  C                   DOW       NOT *IN27 AND SRCDTP = C0CDTP AND WCount < 12
     C                             AND (@CDDP = *Blanks OR SRCDDP = @CDDP)
 
      ** -- Call the select record subroutine
      *
     C                   EXSR      $SelectRcd
 
      ** -- If the record is selected, write the corresponding subfile record
      *
 B2  C                   IF        SelectRec = 'Y'
     C                   EXSR      $FillSF
     C                   ADD       1             S0RRN
     C                   ADD       1             WCount
     C                   WRITE     SD180000S0
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C                   READ      SDSCODD1                               27
 E1  C                   ENDDO
 
      ** Save the number of the last subfile record written
      ** and set up the page to display
      *
     C                   Z-ADD     S0RRN         WSavRRN           4 0
     C                   Z-ADD     S0RRN         C0RRN
 
      ** Default end of subfile to Yes
      *
     C                   MOVE      *On           *IN23
 
      ** Continue loop to see if there is remaining records to display,
      ** in order to set correctly the end of subfile indicator
      *
 B1  C                   DOW       NOT *IN27 AND SRCDTP = C0CDTP AND *IN23
     C                             AND (@CDDP = *Blanks OR SRCDDP = @CDDP)
 
      ** -- Call the select record subroutine
      *
     C                   EXSR      $SelectRcd
 
      ** -- If the record is selected :
      *
      **    . Set end of subfile to No
      **    . Store current key values
      **    . Quit the loop
      *
 B2  C                   IF        SelectRec = 'Y'
     C                   MOVE      *Off          *IN23
     C                   MOVE      SRCDTP        KeyPosCDTP
     C                   MOVE      SRCDDP        KeyPosCDDP
     C                   MOVE      SRCODE        KeyPosCODE
     C                   LEAVE
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C                   READ      SDSCODD1                               27
 E1  C                   ENDDO
 
      ** Do not display the subfile if it is empty
      *                                                               >><<==
     C     S0RRN         COMP      0                                  22
      *    ----------    ------
     C     @LoadSubfl    ENDSR
 
      *========================================================================*
      * $SelectRcd: Tests if a record has to be displayed                      *
      *------------------------------------------------------------------------*
     C     $SelectRcd    BEGSR
      *    ----------    ------
      ** Default the select record flag to Yes (Parameter returned by the routine)
      *
     C                   MOVE      'Y'           SelectRec         1
 
      ** For each SELECTION criterion check if it is not blank and, if not,
      ** if its value exists in the corresponding field of the current file record
      *
      ** -- Status/Reason Code
      *
     C                   IF        EffCODE <> *Blanks AND
     C                             EffCODE <> SRCODE
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Status/Reason Narrative
      *
     C                   IF        EffCDNR <> *Blanks AND
     C                             %SCAN(%TRIM(EffCDNR):SRCDNR) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
      *    ----------    ------
     C     @SelectRcd    ENDSR
 
      *========================================================================*
      * $FillSF   : Load the subfile record with the current file record values*
      *------------------------------------------------------------------------*
     C     $FillSF       BEGSR
      *    ----------    ------
     C                   CLEAR                   SD180000S0
 
     C                   MOVEL     SRCDDP        S0CDDP
     C                   MOVEL     SRCODE        S0CODE
     C                   MOVEL     SRCDNR        S0CDNR
      *    ----------    ------
     C     @FillSF       ENDSR
 
      *========================================================================*
      * $ClrErrSF : Clear program message queue                                *
      *------------------------------------------------------------------------*
     C     $ClrErrSF     BEGSR
      *    ----------    ------
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
      *    ----------    ------
     C     @ClrErrSF     ENDSR
 
      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
 
      ** Re-initialise fields
      *
     C                   MOVEL     PSProcName    ZAPGM
     C                   MOVEL (P) 'SDUSRMSG'    ZAMSGF
     C                   MOVEL     '*SAME'       ZAPGRL
     C                   MOVEL     *Blanks       ZAMSID
     C                   MOVEL     *Blanks       ZAMSDA
     C                   MOVEL     *Blanks       ZAMSTP
      *    ----------    ------
     C     @ZaSndMsg     ENDSR
 
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise copyright array
      *
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
 
      ** Define fields used by the message sending function
      *
     C                   MOVEL     PSProcName    ZAPGM            10
     C                   MOVEL (P) 'SDUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7
 
      ** Clear the current selection DS and the return code
      *
     C                   CLEAR                   CurSelect
     C                   CLEAR                   @RtCd
 
      ** Clear key DS's
      *
     C                   CLEAR                   KeyUsed
     C                   CLEAR                   KeyPos
     C                   CLEAR                   KeySav
 
      ** Check if CSE039 - Automatic Settlement of Trades - is on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM                    @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSE039'      @SARD
 
     C                   IF        @RtCd <> *Blanks
     C                   MOVE      'SE03905'     ZAMSID
     C                   MOVEL (P) '*PRV'        ZAPGRL
     C                   EXSR      $ZaSndMsg
     C                   MOVEL (P) '*FEATUR'     @RtCd
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** The received code type must be 'R' or 'S'
      *
     C                   IF        @CDTP <> 'R' AND @CDTP <> 'S'
     C                   MOVE      'SE03902'     ZAMSID
     C                   MOVEL (P) '*PRV'        ZAPGRL
     C                   EXSR      $ZaSndMsg
     C                   MOVEL (P) '*PARM'       @RtCd
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** The received dependency code type must be blank if code type is 'S'
      *
     C                   IF        @CDDP <> *Blanks AND @CDTP = 'S'
     C                   MOVE      'SE03903'     ZAMSID
     C                   MOVEL (P) '*PRV'        ZAPGRL
     C                   EXSR      $ZaSndMsg
     C                   MOVEL (P) '*PARM'       @RtCd
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** Setup the display for Status or Reason Code selection (*IN13)
      ** and to have the position/selection field "Linked Status" amendable
      ** or not (*IN14).
      *                                                               >><<==
     C     @CDTP         COMP      'S'                                    13
     C     @CDDP         COMP      *Blanks                                14
      *    ----------    ------
     C     @INZSR        ENDSR
 
      *========================================================================*
      * $ExitMod  : Exit Program                                               *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
      ** If there was something wrong, the returned values must be blanked out
      ** and/or reset to the value they had when the program started
      *
     C                   IF        @RtCd <> *Blanks
     C                   MOVE      *Blanks       S0CODE
     C                   MOVE      @CDDP         S0CDDP
     C                   ENDIF
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR
 
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
 
     C                   CALLB     'DBERRCTL'
 
     C                   MOVEL(P)  '*ERROR'      @RtCd
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
**  CPY@
(c) Finastra International Limited 2003
