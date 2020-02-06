     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Request of securities statement - Browse')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE4250 - Midas SE Request of securities statement - Browse   *
      *                                                               *
      *  Function:  This module manages a subfile that allows to work *
      *             with the Request of Statements.                   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 TDA035             Date 02Apr04               *
      *                 CSE040   *CREATE   Date 19Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
 
     FSERQSTL1  IF   E           K DISK    RENAME(SERQSTD0:SERQSTD1)
      ** Midas SE Request of Securities Statement - Index
     F                                     INFSR(*PSSR)
 
     FSERQSTL2  IF   E           K DISK    RENAME(SERQSTD0:SERQSTD2)
      ** Midas SE Request of Securities Statement by Custodian, Type, Branches, ...
     F                                     INFSR(*PSSR)
 
     FSE4250DF  CF   E             WORKSTN SFILE(SE4250S0:S0RRN)
      ** Midas SE Request of Statement - Browse
      *
      *****************************************************************
      * Use of Indicators                                             *
      *                                                               *
      * Display Conditioning Indicators                               *
      *                                                               *
      * 01 - Display Insert                                           *
      * 02 - Display Amend                                            *
      * 03 - Display Enquire                                          *
      * 04 - Display Delete                                           *
      * 05 - Display Release                                          *
      * 06 - Display .......... (Future Use)                          *
      * 07 - Display .......... (Future Use)                          *
      * 08 - Display .......... (Future Use)                          *
      * 09 - Display .......... (Future Use)                          *
      * 10 - Display .......... (Future Use)                          *
      * 11 - Display .......... (Future Use)                          *
      * 12 - Display 'F12=Previous...' & allow use of F12 key         *
      *                                                               *
      * Action key Indicators                                         *
      *                                                               *
      * KC - Exit Program                                             *
      * KE - Refresh Screen                                           *
      * KI - Insert Mode                                              *
      * KL - Previous Screen                                          *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Error On Action Code                                     *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved *
      *  error indicators)                                            *
      *                                                               *
      * Subfile Management Indicators                                 *
      *                                                               *
      * 21 - SFLDSPCTL if *ON / SFLCLR if *OFF                        *
      * 22 - SFLDSP                                                   *
      * 23 - SFLEND                                                   *
      * 24 - SFLNXTCHG                                                *
      * 25 - Rollup                                                   *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * 27 - Access SERQSTL2                                          *
      * 28 - Access SERQSTL1                                          *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************
 
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
 
     D DsUSER        E DS                  EXTNAME(MUSERDD)
      ** User details record format data structure
      *
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS (short) used as output parameter for Access Objects
      *
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
      *
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
      *
 
      ** Current selection
      *
     D CurSelect       DS
     D  CurCUST                            LIKE(C0CUST)
     D  CurDREF                            LIKE(C0DREF)
     D  CurSTTY                            LIKE(C0STTY)
     D  CurSNDR                            LIKE(C0SNDR)
     D  CurSTDT                            LIKE(C0STDT)
     D  CurFREQ                            LIKE(C0FREQ)
     D  CurMREF                            LIKE(C0MREF)
     D  CurCHTP                            LIKE(C0CHTP)
 
      ** Displayed selection
      *
     D ScrSelect       DS
     D  C0CUST
     D  C0DREF
     D  C0STTY
     D  C0SNDR
     D  C0STDT
     D  C0FREQ
     D  C0MREF
     D  C0CHTP
 
      ** Effective Selection
      *
     D EffSelect       DS
     D  EffDREF                            LIKE(C0DREF)
     D  EffSTTY                            LIKE(C0STTY)
     D  EffSNDR                            LIKE(C0SNDR)
     D  EffMSTD                            LIKE(RQMSTD)
     D  EffFREQ                            LIKE(C0FREQ)
     D  EffMREF                            LIKE(C0MREF)
     D  EffCHTP                            LIKE(C0CHTP)
 
      ** Really used key
      *
     D KeyUsed         DS
     D  KeyCUST                            LIKE(RQCUST)
 
      ** Position key
      *
     D KeyLastPos      DS
     D  KeyLstCUST                         LIKE(RQCUST)
     D  KeyLstSTTY                         LIKE(RQSTTY)
     D  KeyLstSNDR                         LIKE(RQSNDR)
     D  KeyLstORIG                         LIKE(RQORIG)
     D  KeyLstFREQ                         LIKE(RQFREQ)
     D  KeyLstDATE                         LIKE(RQDATE)
     D  KeyLstRSEQ                         LIKE(RQRSEQ)
 
      *
      ** Declared variables
      ** ------------------
      *
     D RequestDate     S              5P 0                                      Request Date
     D RequestSeq      S              5P 0                                      Request Sequence
     D DefaultCust     S              6                                         Default Custodian
 
      ** Error indicators array
      *
     D IN40_TO_70      S              1    DIM(31)
 
      ** Working fields
      *
     D WFld            S              3  0
     D StartDate       S               D   DATFMT(*ISO) INZ(D'1971-12-31')      Start Date
     D WkDate          S               D   DATFMT(*ISO)                         Working Date
     D WkActCode       S                   LIKE(ActionCode)                     Working Act. Code
     D WkSNDR          S                   LIKE(RQSNDR)                         Working Sender Brch
     D WkORIG          S                   LIKE(RQORIG)                         Working Orig. Branch
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *
 
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    OptionIn         10
     C                   PARM                    CallerIn         10
     C     C0CUST        PARM                    @Cust             6            Custodian
 
      ** Key lists
      *
     C     KRQSTL1       KLIST
     C                   KFLD                    S0DATE                         Request Date
     C                   KFLD                    S0RSEQ                         Request Sequence
 
     C     KeyPos        KLIST
     C                   KFLD                    KeyCUST                        Custodian
 
     C     KeyLstPos     KLIST
     C                   KFLD                    KeyLstCUST                     Custodian
     C                   KFLD                    KeyLstSTTY                     Type Statement
     C                   KFLD                    KeyLstSNDR                     Sending Branch
     C                   KFLD                    KeyLstORIG                     Originat. Branch
     C                   KFLD                    KeyLstFREQ                     Frequence
     C                   KFLD                    KeyLstDATE                     Request Date
     C                   KFLD                    KeyLstRSEQ                     Request Sequence
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR SR
 
      ** Initialize the selection
      *
     C                   EXSR      $IniSelect
 
      ** Initialize the subfile
      *
     C                   EXSR      $IniSubFil
 
      ** Load the subfile
      *
     C                   EXSR      $LoadSubfl
 
      ** Main loop (based on F3 and F12 indicators)
      *  ------------------------------------------
     C                   DOW       NOT *INKC AND NOT *INKL
 
      ** -- Informational message if the subfile is empty
      *
     C  N22              MOVE      'ST00040'     ZAMSID
     C  N22              EXSR      $ZaSndMsg
 
      ** -- Display the screen (error messages, header and subfile)
      *
     C                   WRITE     SE4250H0
     C                   WRITE     #MSGCTL
     C                   EXFMT     SE4250C0
 
      ** -- Clear the error messages subfile
      *
     C                   EXSR      $ClrErrSF
 
      ** -- Action keys management
      *     ----------------------
      ** ---- F3 ==> Exit Module
      *
     C                   IF        *INKC
     C                   MOVEL (P) '*EXIT'       RetCodeOut
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
 
      ** ---- F9 ==> Add a record
      *
     C                   IF        *INKI
     C                   EXSR      $InsertRcd
 
      ** ------ If F3 taken during the addition process => Exit
      *
     C                   IF        RetCodeIn = '*EXIT'
     C                   MOVEL (P) '*EXIT'       RetCodeOut
     C                   LEAVE
     C                   ENDIF
 
      ** ------ Re-load subfile
      *
     C                   EXSR      $IniSubFil
     C                   EXSR      $LoadSubfl
     C                   ITER
     C                   ENDIF
 
      ** ---- F12 ==> Back to previous screen
      *
     C                   IF        *INKL
     C                   MOVEL(P)  '*PRV'        RetCodeOut
     C                   ITER
     C                   ENDIF
 
      ** ---- Roll-Up
      *
     C                   IF        *IN25
 
      ** ------ Restore stored key value and reposition file in order to
      **        continue subfile filling from the right point
      *
     C     KeyLstPos     CHAIN     SERQSTL2                           27
 
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
 
      ** -- Action codes management (If *in22 is on, the subfile exists)
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
 
      ** Custodian number
      *
     C                   IF        C0CUST <> *Blanks AND FillKey = 'Y'
     C                   MOVEL     C0CUST        KeyCUST
     C                   ELSE
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
      ** Depot Reference
      *
     C                   MOVEL     C0DREF        EffDREF
 
      ** Type of Statement
      *
     C                   MOVEL     C0STTY        EffSTTY
 
      ** Sending branch
      *
     C                   MOVEL     C0SNDR        EffSNDR
 
      ** Start Date
      *
     C                   MOVE      *ZEROS        EffMSTD
     C                   IF        C0STDT <> *BLANKS
     C  N98*DMY0         TEST(DE)                C0STDT
     C   98*MDY0         TEST(DE)                C0STDT
     C                   IF        NOT %ERROR
     C  N98*DMY0         MOVE      C0STDT        WkDate
     C   98*MDY0         MOVE      C0STDT        WkDate
     C     WkDate        SUBDUR    StartDate     EffMSTD:*D
     C                   ENDIF
     C                   ENDIF
 
      ** Frequency Code
      *
     C                   MOVEL     C0FREQ        EffFREQ
 
      ** Message Request Reference
      *
     C                   MOVEL     C0MREF        EffMREF
 
      ** Type of last change
      *
     C                   MOVEL     C0CHTP        EffCHTP
 
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
 
      ** Check if action code is within the action code array and
      ** correct according to the displayed record deletion flag
      *
     C                   READC     SE4250S0                               99
 
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
      **      The valid action codes are defined in SPF. Thus, this test is done during the
      **      validation of user authority on the branch.
      **      Validate the user authority On the Sending and Originating Branches for the action,
      **      In case of Release, chech if the user is a System Routing Officer.
     C                   MOVE      S0ACTCDE      WkActCode
     C                   MOVE      S0SNDR        WkSNDR                         Sending Branch
     C                   MOVE      S0ORIG        WkORIG                         Originating Branch
     C                   EXSR      $ValAutBrc
     C                   IF        @ERR > *ZEROS
     C                             OR S0ACTCDE = 'I'
     C                             OR S0ACTCDE = 'R'
     C                             AND ROUF <> 'Y'
     C                   MOVE      *On           *IN41
     C                   MOVE      'ST00041'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      'N'           ValidCodes
     C                   ELSE
      *
      **      It is not allowed to amend, delete or release a pending or released request.
     C                   IF        S0ACTCDE = 'A'
     C                             OR S0ACTCDE = 'D'
     C                             OR S0ACTCDE = 'R'
     C                   IF        S0CHTP = 'P'
     C                             OR S0CHTP = 'R'
     C                             OR S0CHTP = 'D'
     C                   MOVE      *On           *IN41
     C                   MOVE      'ST00042'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      'N'           ValidCodes
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   UPDATE    SE4250S0
     C                   READC     SE4250S0                               99
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
     C                   READC     SE4250S0                               99
 
 B1  C                   DOW       NOT *IN99
     C                   MOVE      *Off          *IN41
     C                   MOVE      *Off          *IN24
 
      ** Call the maintenance of request of statements
      *
     C                   CALLB     'SE4251'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      S0ACTCDE      WkActCode
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM      S0DATE        RequestDate
     C                   PARM      S0RSEQ        RequestSeq
     C                   PARM      *Blanks       DefaultCust
 
      **  Update SFL details
      *
 B3  C                   IF        RetCodeIn = *Blanks
     C     KRQSTL1       CHAIN     SERQSTL1                           28
 
 B4  C                   IF        NOT *IN28
     C                   EXSR      $FillSF
     C                   UPDATE    SE4250S0
 E4  C                   ENDIF
 
 X3  C                   ELSE
 
      ** F12 from called program
      *
 B4  C                   IF        RetCodeIn = '*PRV'
     C                   MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    SE4250S0
 E4  C                   ENDIF
 
      ** F3 from called program
      *
     C                   IF        RetCodeIn = '*EXIT'
     C                   MOVE      '*EXIT'       RetCodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF
 
     C                   LEAVESR
 
 E3  C                   ENDIF
 
     C                   READC     SE4250S0                               99
 E1  C                   ENDDO
 
      ** All the action codes have been processed ==> Re-load the subfile
      *
     C                   EXSR      $IniSubFil
     C                   EXSR      $LoadSubfl
 
      *    ----------    ------
     C     @PrcActCde    ENDSR
 
      *========================================================================*
      * $InsertRcd: Insert a new record                                        *
      *------------------------------------------------------------------------*
     C     $InsertRcd    BEGSR
      *    ----------    ------
 
      ** Call the maintenance of request of statements
      *
     C                   CALLB     'SE4251'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      'I'           WkActCode
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM      *Zeros        RequestDate
     C                   PARM      *Zeros        RequestSeq
     C                   PARM      C0CUST        DefaultCust
 
      *    ----------    ------
     C     @InsertRcd    ENDSR
 
      *========================================================================*
      * $IniSubFil: Initialise Subfile                                         *
      *------------------------------------------------------------------------*
     C     $IniSubFil    BEGSR
      *    ----------    ------
      ** Clear the subfile
      *
     C                   MOVE      *Off          *IN21
     C                   WRITE     SE4250C0
     C                   MOVE      *On           *IN21
 
      ** Reset the saving field of the subfile line number
      *
     C                   Z-ADD     0             WSavRRN
 
      ** Position within SERQSTL2 according to first key field
      **     If not blank ==> key value
      **     If blank     ==> *LOVAL
      *
     C                   IF        KeyCUST <> *Blanks
     C     KeyPos        SETLL     SERQSTL2
     C                   ELSE
     C     *LOVAL        SETLL     SERQSTL2
     C                   ENDIF
 
      ** First read of SERQSTL2
      *
     C                   READ      SERQSTL2                               27
 
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
 
      ** Fill subfile loop
      *
 B1  C                   DOW       NOT *IN27 AND WCount < 13
 
      ** -- Call the select record subroutine
      *
     C                   EXSR      $SelectRcd
 
      ** -- If the record is selected, write the corresponding subfile record
      *
 B2  C                   IF        SelectRec = 'Y'
     C                   EXSR      $FillSF
     C                   ADD       1             S0RRN
     C                   ADD       1             WCount
     C                   WRITE     SE4250S0
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C                   READ      SERQSTL2                               27
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
 B1  C                   DOW       NOT *IN27 AND *IN23
 
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
     C                   MOVE      RQCUST        KeyLstCUST
     C                   MOVE      RQSTTY        KeyLstSTTY
     C                   MOVE      RQSNDR        KeyLstSNDR
     C                   MOVE      RQORIG        KeyLstORIG
     C                   MOVE      RQFREQ        KeyLstFREQ
     C                   MOVE      RQDATE        KeyLstDATE
     C                   MOVE      RQRSEQ        KeyLstRSEQ
     C                   LEAVE
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C                   READ      SERQSTL2                               27
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
 
      ** Check the user authority on the Sending and Originating Branches in Enquiry mode
      *
     C                   MOVE      'E'           WkActCode
     C                   MOVE      RQSNDR        WkSNDR                         Sending Branch
     C                   MOVE      RQORIG        WkORIG                         Originating Branch
     C                   EXSR      $ValAutBrc
     C                   IF        @ERR > *ZEROS
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** For each SELECTION criterion check if it is not blank and, if not,
      ** if its value exists in the corresponding field of the current file record
      *
      ** -- Depot Reference
      *
     C                   IF        EffDREF <> *Blanks
     C                   EVAL      WFld = %SCAN(%TRIM(EffDREF):RQDREF)
 
     C                   IF        Wfld = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
     C                   ENDIF
 
      ** -- Statement Type
      *
     C                   IF        EffSTTY <> *Blanks
     C                   EVAL      WFld = %SCAN(%TRIM(EffSTTY):RQSTTY)
 
     C                   IF        Wfld = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
     C                   ENDIF
 
      ** -- Sending Branch
      *
     C                   IF        EffSNDR <> *Blanks
     C                   EVAL      WFld = %SCAN(%TRIM(EffSNDR):RQSNDR)
 
     C                   IF        Wfld = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
     C                   ENDIF
 
      ** -- Start Date
      *
     C                   IF        EffMSTD <> *Zeros AND EffMSTD <> RQMSTD
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Frequency Code
      *
     C                   IF        EffFREQ <> *Blanks AND EffFREQ <> RQFREQ
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Message Request Reference
      *
     C                   IF        EffMREF <> *Blanks
     C                   EVAL      WFld = %SCAN(%TRIM(EffMREF):RQMREF)
 
     C                   IF        Wfld = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
     C                   ENDIF
 
      ** -- Type of last change
      *
     C                   IF        EffCHTP <> *Blanks AND EffCHTP <> RQCHTP
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
     C                   CLEAR                   SE4250S0
 
     C                   MOVE      RQDATE        S0DATE                         Input Date
     C                   MOVE      RQRSEQ        S0RSEQ                         Request Sequence
     C                   MOVE      RQORIG        S0ORIG                         Originating Branch
     C                   MOVE      RQCUST        S0CUST                         Custodian Number
     C                   MOVE      RQDREF        S0DREF                         Depot Reference
     C                   MOVE      RQSTTY        S0STTY                         Statement Type
     C                   MOVE      RQSNDR        S0SNDR                         Sending Branch
     C     StartDate     ADDDUR    RQMSTD:*D     WkDate                         Start Date
     C  N98*DMY0         MOVE      WkDate        S0STDT
     C   98*MDY0         MOVE      WkDate        S0STDT
     C                   MOVE      RQFREQ        S0FREQ                         Frequency Code
     C                   MOVE      RQMREF        S0MREF                         Message Request Refe
     C                   MOVE      RQCHTP        S0CHTP                         Type of last change
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
      * $ValAutBrc : Validate the user authority on the branch                 *
      *------------------------------------------------------------------------*
     C     $ValAutBrc    BEGSR
      *    ----------    ------
 
      ** The user should be authorize to Sending and Originating branches.
 
     C  N37              CALL      'ZVACTU'
     C                   PARM      WkActCode     @ZACTN            1
     C                   PARM      *Zeros        @ERR              1 0
     C   37              CALL      'ZVACTBU'
     C                   PARM      WkActCode     @ZACTN
     C                   PARM      WkSNDR        @ZBR              3
     C                   PARM      *Zeros        @ERR
      *
     C                   IF        @ERR > *Zeros
     C                   LEAVESR
     C                   ENDIF
 
     C  N37              CALL      'ZVACTU'
     C                   PARM      WkActCode     @ZACTN            1
     C                   PARM      *Zeros        @ERR              1 0
     C   37              CALL      'ZVACTBU'
     C                   PARM      WkActCode     @ZACTN
     C                   PARM      WkORIG        @ZBR              3
     C                   PARM      *Zeros        @ERR
 
      *    ----------    ------
     C     @ValAutBrc    ENDSR
 
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
 
      ** Define fields used by the message sending function
      *
     C                   IF        CallerIn <> *Blanks
     C                   MOVEL     CallerIn      ZAPGM            10
     C                   MOVE      *ON           *IN12                          F12=Previous
     C                   ELSE
     C                   MOVEL     PSProcName    ZAPGM
     C                   MOVE      *OFF          *IN12                          F12=Previous
     C                   ENDIF
 
     C                   MOVEL     'SEUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7
 
      ** Retrieve User Details
      *
     C                   CALL      'AOUSERR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      PSUSER        @USRP            10
     C     DsUSER        PARM      *Blanks       DSSDY
     C                   IF        @RTCD <> *Blanks
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
     C     AGDFF         COMP      'M'                                    98    Date format
     C     AGMBIN        COMP      'Y'                                    37    Branch
 
      ** Initialize action codes
      *
 B1  C                   SELECT
 X1  C                   WHEN      OptionIn = '*MAINT'
     C                   MOVEA     '1111'        *IN(01)                        Maintenance Code
     C     ROUF          COMP      'Y'                                    05    Release
      *
 X1  C                   WHEN      OptionIn = '*DSPLY'
     C                   MOVE      *ON           *IN03                          Enquiry
      *
 X1  C                   OTHER
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = *Blanks                             *=======*
     C                   EVAL      DBKey  = 'Wrong Option'                      *       *
     C                   EVAL      DBPgm  = ZAPGM                               * Error *
     C                   EVAL      DBase  = 001                                 *       *
     C                   EVAL      DBMod  = PSProcMod                           *  001  *
     C                   EVAL      DBProc = PSProcName                          *       *
     C                   OUT       LDA                                          *=======*
     C                   EXSR      *PSSR
 E1  C                   ENDSL
 
      ** Clear the current selection DS
      *
     C                   CLEAR                   CurSelect
 
      ** Clear key DS's
      *
     C                   CLEAR                   KeyLastPos
      *    ----------    ------
     C     @INZSR        ENDSR
 
      *========================================================================*
      * $ExitMod  : Exit Program                                               *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
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
 
     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
**  CPY@
(c) Finastra International Limited 2003
