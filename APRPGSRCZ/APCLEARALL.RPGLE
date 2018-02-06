     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Clear all volatile files')
      *****************************************************************
      *                                                               *
      *  Midas - APIs module                                          *
      *                                                               *
      *  APCLEARALL - Clear all volatile files                        *
      *                                                               *
      *  Function:  This module clears all files used by the Midas    *
      *             APIs which require it; the clearing is restriced  *
      *             by an ICD flag.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 248587             Date 19Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 228542             Date 11Aug04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068             DATE 25JUN02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032             Date 26Apr99               *
      *                 167303             Date 09Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP030             Date 12Mar99               *
      *                 156535             Date 06Mar99               *
      *                 147775             Date 17Nov98               *
      *                 147987             Date 17Nov98               *
      *                 CAP002  *CREATE    Date 25Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  248587 - Component APCLEARALL failed. Applied fix 217490.    *
      *  217490 - APCLEARALL fails to due missing ABVEFUNDPD.  Func-  *
      *           code FUND shares invalid file MMVELDNIPD.  This     *
      *           accounts for the lack of ABVEFUNDPD.                *
      *  228542 - RGZPFM command has changed at V5R3. Replace call to *
      *           ZACRGZFILE with call to SCC000060.                  *
      *  CAP068 - Changed to work for FPRT which has two valid files  *
      *           LEVFCLMPD and LEVFCLNPD and two exception error     *
      *           files LEVEFCLMPD and LEVEFCLNPD.                    *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *  167303 - Reorganize deleted records from 'valid' files.      *
      *  CAP030 - APIs for SE Price Input                             *
      *  156535 - Do not clear invalid files for Rates Feed APIs      *
      *  147775 - General FF API error fixes: addition of special     *
      *           processing to cope with the fact that the FF files  *
      *           have a slightly different naming structure from     *
      *           the others.  The invalids do not contain the        *
      *           function code TRAN, so they have been excluded from *
      *           generic processing and added to specific processing;*
      *           and the invalid broker and customer settlements     *
      *           files have also been added to specific processing.  *
      *  147987 - Module fails when function code is less than four   *
      *           bytes, as is the case with FRAs.  Added a %trim     *
      *           function.                                           *
      *           Also call UTSETJOBSW to ensure that job switches    *
      *           are set, to indicate errors to caller.              *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FAPDBINFPD IF   E             DISK    USROPN
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
 
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
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  EndOfFile             99     99
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
 
      ** The next section will not be needed until the retention period
      ** functionality is implemented:
     D*RUNDAT******* E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Layout for the RUNDAT data area
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Mode in which function called (C=Close of Business, O=On request)
     D Mode            S              1A
 
      ** File to clear
     D File            S             10A
     D Member          S             10A                                                      228542
 
      ** Job switches string for passing to UTSETJOBSW                                        147987
     D Switches        S              8A   INZ('XXXXXXXX')                                    147987
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** If Mode is COB and file cleardown is not required, leave
      ** the module; otherwise continue.
      ** The API ICD file includes a retention period field (GHRTPD); the
      ** intention is that users will be able to select a number days for
      ** which to keep transaction data.  However this ability is not
      ** implemented at present.
     C                   IF        GHCLIN = 'Y' OR Mode = 'O'
 
      ** Read through the APDBINFPD file.  For each transaction type
      ** listed there, there are two files to clear.  Subroutines
      ** GetInvalid and GetError return these file names in field File.
     C                   OPEN      APDBINFPD
 
     C                   DOU       EndOfFile = True
 
     C                   READ      APDBINFPD                              99
 
     C                   IF        EndOfFile = True
     C                   LEAVE
     C                   ENDIF
 
      ** Get the name of the invalid transactions file for this transaction
      ** type
      ** But don't do this for the FF invalid files, as they don't share        147775
      ** the transaction ID with their valid file.  They are handled in the     147775
      ** specific-files list below.                                             147775
      ** Ignore Rates Feed APIs (no screen)                                     156535
      ** Ignore Journal Entry API.  This API has no Invalid                                   CAP032
      ** Transaction files.                                                                   CAP032
      ** Funding participants (FPRT) has two exception error files                            CAP068
      ** LEVEFCLMPD and LEVEFCLNPD and two valid files LEVFCLMPD and                          CAP068
      ** LEVFCLNPD which need to be cleared separately.                                       CAP068
      ** Although the invalid file LEIFPRTPD is named ok for                                  CAP068
      ** consistency this is also cleared separately.                                         CAP068
     C                   IF        NOT(                                         147775
     C                                 AQFNCODE = 'TRAN' and AQMIDMOD = 'FF'    147775
     C                                 OR AQFNCODE = 'FWRT' and AQMIDMOD = 'FD' 156535
     C                                 OR AQFNCODE = 'INTR' and AQMIDMOD = 'FD' 156535
     C                                 OR AQFNCODE = 'PRCS' and AQMIDMOD = 'SE' CAP030
     C                                 OR AQFNCODE = 'BITH' and AQMIDMOD = 'GL'               CAP032
     C                                 OR AQFNCODE = 'BITP' and AQMIDMOD = 'GL'               CAP032
     C                                 OR AQFNCODE = 'FPRT' and AQMIDMOD = 'LE'               CAP068
     C                                )                                         147775
                                                                                147775
     C                   EXSR      GetInvalid
     C                   EXSR      ClearFile
                                                                                147775
     C                   ENDIF                                                  147775
                                                                                167303
      ** Get the name of the valid file for this transaction                    167303
      ** type                                                                   167303
     C                   EVAL      File = AQUPDFIL                              167303
     C                   EXSR      ReorgFile                                    167303
 
      ** Get the name of the errors file for this transaction
      ** type
      *                                                                                       217490
      ** Exclude this processing for function code FUND as it shares an                       217490
      ** invalid file with LDNI (MMVELDNIPD).                                                 217490
      *                                                                                       217490
     C     AQFNCODE      IFEQ      'FUND'                                                     217490
     C     AQMIDMOD      ANDEQ     'AB'                                                       217490
     C                   ELSE                                                                 217490
     C                   EXSR      GetError
     C                   EXSR      ClearFile
     C                   ENDIF                                                                217490
 
     C                   ENDDO
 
      ** Clear each of the files not defined by a transaction type
     C                   EVAL      File = 'APOUTPUTPD'
     C                   EXSR      ClearFile
 
     C                   EVAL      File = 'APEXCPERPD'
     C                   EXSR      ClearFile
 
     C                   EVAL      File = 'APIDSETPD'
     C                   EXSR      ClearFile
 
     C                   EVAL      File = 'APUNAUTHPD'
     C                   EXSR      ClearFile
 
     C                   EVAL      File = 'ZATRNLOGPD'
     C                   EXSR      ClearFile
 
     C                   EVAL      File = 'ZATRNERRPD'
     C                   EXSR      ClearFile
 
     C                   EVAL      File = 'FFIEXTRPD'                                         147775
     C                   EXSR      ClearFile                                                  147775
                                                                                              147775
     C                   EVAL      File = 'FFIOTCCPD'                                         147775
     C                   EXSR      ClearFile                                                  147775
                                                                                              147775
     C                   EVAL      File = 'FFIBSETPD'                                         147775
     C                   EXSR      ClearFile                                                  147775
                                                                                              147775
     C                   EVAL      File = 'FFICSETPD'                                         147775
     C                   EXSR      ClearFile                                                  147775
                                                                                              CAP068
      ** Funding participants (FPRT) Invalid file.                                            CAP068
     C                   EVAL      File = 'LEIFPRTPD'                                         CAP068
     C                   EXSR      ClearFile                                                  CAP068
                                                                                              CAP068
      ** Funding participants (FPRT) Valid file - record A.                                   CAP068
     C                   EVAL      File = 'LEVFCLMPD'                                         CAP068
     C                   EXSR      ReorgFile                                                  CAP068
                                                                                              CAP068
      ** Funding participants (FPRT) Valid file - record B.                                   CAP068
     C                   EVAL      File = 'LEVFCLNPD'                                         CAP068
     C                   EXSR      ReorgFile                                                  CAP068
                                                                                              CAP068
      ** Funding participants (FPRT) Exception error file  - record A.                        CAP068
     C                   EVAL      File = 'LEVEFCLMPD'                                        CAP068
     C                   EXSR      ClearFile                                                  CAP068
                                                                                              CAP068
      ** Funding participants (FPRT) Exception error file  - record B.                        CAP068
     C                   EVAL      File = 'LEVEFCLNPD'                                        CAP068
     C                   EXSR      ClearFile                                                  CAP068
                                                                                              147775
     C                   CLOSE     APDBINFPD
 
     C                   ENDIF
 
      ** If an error was found during processing, indicate this to the
      ** COB calling structure by setting on U7 and U8.
     C                   IF        ErrorFound = 'Y'
 
     C                   EVAL      *inu7 = True
     C                   EVAL      *inu8 = True
     C                   EVAL      Switches = 'XXXXXX' + *inu7 + *inu8          147987
                                                                                147987
     C                   RESET                   ReturnCode                     147987
     C                   CALLB     'UTSETJOBSW'                                 147987
     C                   PARM                    ReturnCode                     147987
     C                   PARM                    Switches                       147987
                                                                                147987
      ** If there was a problem with the switch-setting module set LR           147987
      ** on to update the job switches with the module's copy.                  147987
     C                   IF        ReturnCode <> *blank                         147987
     C                   EVAL      *inlr = True                                 147987
     C                   ENDIF                                                  147987
                                                                                147987
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetInvalid - Get the name of the invalid transactions file    *
      *              for a transaction type                           *
      *                                                               *
      * Called by: main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GetInvalid    BEGSR
 
      ** The invalid file name is mmIffffPD, where mm is a Midas Module
      ** ID, and ffff is a function code or transaction type.
     C****************** EVAL      File = AQMIDMOD + 'I' + AQFNCODE + 'PD'      147987
     C                   EVAL      File = AQMIDMOD + 'I' + %trim(AQFNCODE)      147987
     C                                    + 'PD'                                147987
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
 
      *****************************************************************
      *                                                               *
      * GetError - Get the name of the exception errors file          *
      *            for a transaction type                             *
      *                                                               *
      * Called by: main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GetError      BEGSR
 
      ** The invalid file name is mmVEffffPD, where mm is a Midas Module
      ** ID, and ffff is a function code or transaction type.
     C****************** EVAL      File = AQMIDMOD + 'VE' + AQFNCODE + 'PD'     147987
     C                   EVAL      File = AQMIDMOD + 'VE' + %trim(AQFNCODE)     147987
     C                                    + 'PD'                                147987
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ClearFile - Clear a file                                      *
      *                                                               *
      * Called by: main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ClearFile     BEGSR
 
     C                   CLEAR                   ReturnCode
     C                   CALLB     'ZACCLRFILE'
     C                   PARM                    ReturnCode
     C                   PARM                    File
 
      ** If the return code is not blank, an error has occurred in the
      ** clearing process.  Indicate the condition locally, but do not
      ** stop processing.
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      ErrorFound = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                    167303
      *****************************************************************         167303
      *                                                               *         167303
      * ReorgFile - Reorganize a file                                 *         167303
      *                                                               *         167303
      * Called by: main                                               *         167303
      *                                                               *         167303
      * Calls: None                                                   *         167303
      *                                                               *         167303
      *****************************************************************         167303
                                                                                167303
     C     ReorgFile     BEGSR                                                  167303
                                                                                167303
     C**********         CLEAR                   ReturnCode                     167303        228542
     C**********         CALLB     'ZACRGZFILE'                                 167303        228542
     C**********         PARM                    ReturnCode                     167303        228542
     C**********         PARM                    File                           167303        228542
                                                                                167303
     C                   EVAL      Member = '*FIRST    '                                      228542
                                                                                              228542
     C                   CALL      'SCC000060'                                                228542
     C                   PARM                    File                                         228542
     C                   PARM                    Member                                       228542
      *                                                                                       228542
      ** If the return code is not blank, an error has occurred in the          167303
      ** reorganzing process.  Indicate the condition locally, but do not       167303
      ** stop processing.                                                       167303
     C**********         IF        ReturnCode <> *blanks                               167303 228542
     C                   IF        *INU7 = '1' and *INU8 = '1'                                228542
     C                   EVAL      ErrorFound = 'Y'                             167303
     C                   ENDIF                                                  167303
                                                                                167303
     C                   ENDSR                                                  167303
                                                                                167303
      *****************************************************************         167303
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Parameters received from caller
      ** -------------------------------
      ** Mode in which function called (1A)
     C                   PARM                    Mode
 
      ** Access the API ICD
      ** (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** The next section will not be needed until the retention period
      ** functionality is implemented:
      ** Get the run date from the RUNDAT data area
     C****************** IN        RUNDAT
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
