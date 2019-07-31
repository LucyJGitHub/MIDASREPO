     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statmts Prod. Requests - Browse')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SESTPRBRW - Statement Production Requests - Browse     *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of Statement Production        *
      *             Requests for selection , the other picks off the  *
      *             selection made.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA035             Date 02Apr04               *
      *                 CSE040   *CREATE   Date 17Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSESTPRBDF CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SESTPRBS0:@@RRN)
      ** Midas SE Statement Production Requests - Browse Display File

     FSESTPRL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SESTPRD0:SESTPRD2)
      ** Midas SE Statement Production Request - Index

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      ** Table of field numbers and names (dummy use)

      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       01  Enables Display of Action Code "X"                  *
      *       04  Enquire Mode (Disable Amend, Delete, Authorise & CF09)
      *       12  Enables CF12 - when called by another program -     *
      *       21  SFLDSPCTL if *On / SFLCLR if *Off                   *
      *       22  SFLDSP and Displays Action Codes if *On             *
      *       23  SFLEND if *On                                       *
      *       24  SFLNXTCHG if *On                                    *
      *       25  Roll up (when not SFLEND)                           *
      *       36  Protect Fields if *On                               *
      *       41  Subfile Action Code Error                           *
      *       99  Multi-purpose                                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------

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

     D SESTPR        E DS                  EXTNAME(SESTPRPD)
      ** Statement Production Request record layout

     D SDUSER        E DS                  EXTNAME(MUSERDD)
      ** External DS for User Details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for access programs

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long DS for access programs

      ** Current screen selection criteria
     D CurrSel         DS
     D   C0CUST
     D   C0RECP
     D   C0CSSN
     D   C0TYPE
     D   C0SNDR
     D   C0MSTD
     D   C0FREQ
     D   C0NSTD
     D   C0CHTP

      ** Saved screen selection criteria
     D SavSel          DS
     D   SavCUST                           LIKE(C0CUST)
     D   SavRECP                           LIKE(C0RECP)
     D   SavCSSN                           LIKE(C0CSSN)
     D   SavTYPE                           LIKE(C0TYPE)
     D   SavSNDR                           LIKE(C0SNDR)
     D   SavMSTD                           LIKE(C0MSTD)
     D   SavFREQ                           LIKE(C0FREQ)
     D   SavNSTD                           LIKE(C0NSTD)
     D   SavCHTP                           LIKE(C0CHTP)

      ** Split up of the Statement Production Request Reference
     D DDStPRRef       DS
      ** -- Main key (used in SIN function)
     D  DDDATE                        6A
     D  DDRSEQ                        7A
      ** -- Alternative key (used in CTL & RPR functions)
     D  DDCUST                        6A
     D  DDTYPE                        2A
     D  DDSNDR                        3A
     D  DDRECP                       11A
     D  DDFREQ                        1A

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
      *
      ** WARNING: The main loop of this module is based on the RPG cycle.
      **          I.e. the detail processing will repeat itself until the
      **          module is authorized to return to the caller.
      ** Initialization
      *
     C                   EXSR      INIT

      ** Build Sub-file and write/read the screen
      *
     C                   IF        @BDSFL = 'Y'
     C                   EXSR      BLDSFL
     C                   EVAL      @BDSFL = *Blank
     C                   ENDIF

      ** Process the last user input and/or
      ** Read and validate the next modified Subfile Record
      *
     C                   IF        @RDSFL = 'Y'
     C                   EVAL      TimeToGo = 'N'
     C                   EXSR      RDSFLR
     C                   ENDIF

      ** Return to the caller at the right moment
      *
     C                   IF        TimeToGo = 'Y'
     C                   RETURN
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDSFL - Build the subfile and write/read the screen
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** Save the current selection criteria
      *
     C                   EVAL      SavSel = CurrSel
      *
      ** Clear the subfile and initialise its relative record number
      *
     C                   SETOFF                                       212223
     C                   WRITE     SESTPRBC0
     C                   SETON                                        21
      *
     C                   Z-ADD     0             @@RRN             5 0
     C                   Z-ADD     0             SavRRN            5 0
      *
      ** Set file pointer on key displayed on screen
      *
     C     C0CUST        SETLL     SESTPRD2
      *
      ** Read the next record and validate it for display
      *
     C                   EXSR      RdStPR
      *
      ** Fill subfile pages and display them as long as
      ** the user presses Roll-up
      *
     C                   EXSR      SFPages
      *
      ** Return to the caller
      *
     C                   EVAL      TimeToGo = 'Y'
      *
     C     EndBLDSFL     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFPages - Fill subfile pages and display them as long as Roll-up is used
      *****************************************************************
     C     SFPages       BEGSR
      *
      ** Restore the last subfile record key value
      *
     C                   Z-ADD     SavRRN        @@RRN
      *
      ** No SFLNXTCHG, nor error on Action Code
      *
     C                   SETOFF                                       2441
      *
      ** Loop until Roll-up isn't used
      *
 B1  C                   DOU       NOT *IN25
     C                   Z-ADD     0             SFCount           3 0
      *
 B2  C                   DOW       NOT %EoF(SESTPRL2) AND SFCount < 12
      *
      ** If the record is selected for display
      *
 B3  C                   IF        WRecordOK = 'Y'
      *
      ** Format record fields for output
      *
     C                   EXSR      FMTStPR
      *
      ** Write the subfile record
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             SFCount
     C                   WRITE     SESTPRBS0
 E3  C                   ENDIF
      *
      ** Read the next record and validate it for display
      *
     C                   EXSR      RdStPR
 E2  C                   ENDDO
      *
      ** Look for the next displayable record in order to set end
      ** of subfile or not (also position the file to start a new
      ** subfile page)
      *
 B2  C                   DOW       NOT %Eof(SESTPRL2) AND WRecordOK <> 'Y'
     C                   EXSR      RdStPR
 E2  C                   ENDDO
      *
      ** Set end of subfile On or Off
      *
 B2  C                   IF        %Eof(SESTPRL2)
     C                   SETON                                        23
 E2  C                   ENDIF
      *
      ** Display the subfile if there is at least one record
      ** Otherwise, send a message "no data to display"
      *
     C                   IF        @@RRN > 0
     C                   SETON                                        22
     C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx)   = 'ST00040'
     C                   ENDIF
      *
      ** Write/Read the screen
      *
     C                   EVAL      C0RRN = @@RRN
     C                   EXSR      Screen
 E1  C                   ENDDO
      *
      ** Save the current subfile key value
      *
     C                   Z-ADD     @@RRN         SavRRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Screen - Write and read the screen
      *****************************************************************
     C     Screen        BEGSR
      *
      ** The following /COPY doesn't clear the program message queue when
      ** there are no errors, causing messages persistence on screen.
      ** So, clear manually
      *
     C                   IF        MsgIDArr(1) = *Blanks
     C                   MOVEA     *Blanks       WkMsgIDArr
     C                   MOVEA     *Blanks       WkFldNmArr
     C                   MOVEA     *Blanks       WkMsgDtArr
     C                   EVAL      ClrPgmMsgQ = 'Y'
     C                   EXSR      ProcMsgs
     C                   ENDIF
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Clear message arrays
      *
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
     C                   MOVE      0             Idx               3 0
      *
      ** Output and read the screen
      *
     C                   WRITE     SESTPRBCM                                    Options+Keys+Msgs
     C                   EXFMT     SESTPRBC0                                    Subfile control
      *
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * RdStPR - Read the next record and validate it for display
      *****************************************************************
     C     RdStPR        BEGSR
      *
      ** Reset the "record ok" flag
      *
     C                   MOVE      'Y'           WRecordOK         1
      *
      ** Read the next record
      *
     C                   READ      SESTPRD2
      *
      ** Validate the record for display if not End of File:
      ** .The user must have authority to view it
      ** .The record must correspond to the selection criteria
      *
 B1  C                   IF        NOT %EoF(SESTPRL2)
      *
      ** Check authority
      *
     C                   EVAL      ZACTN = 'E'
     C                   EVAL      ZBR   = SPSNDR
     C                   EXSR      ChkAut
      *
 B2  C                   IF        @@ERR <> 0
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdStPR
 X2  C                   ELSE
     C                   EVAL      ZBR = SPORIG
     C                   EXSR      ChkAut
      *
 B3  C                   IF        @@ERR <> 0
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdStPR
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** Recipient number
      *
 B2  C                   IF        C0RECP <> *Blanks AND
     C                             %Scan(%Trim(C0RECP):SPRECP) = 0
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdStPR
 E2  C                   ENDIF
      *
      ** Type of statement
      *
 B2  C                   IF        C0TYPE <> *Blanks AND SPTYPE <> C0TYPE
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdStPR
 E2  C                   ENDIF
      *
      ** Sending Branch
      *
 B2  C                   IF        C0SNDR <> *Blanks AND SPSNDR <> C0SNDR
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdStPR
 E2  C                   ENDIF
      *
      ** Frequency
      *
 B2  C                   IF        C0FREQ <> *Blanks AND SPFREQ <> C0FREQ
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdStPR
 E2  C                   ENDIF
      *
      ** Status (last change type)
      *
 B2  C                   IF        C0CHTP <> *Blanks AND SPCHTP <> C0CHTP
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdStPR
 E2  C                   ENDIF
      *
      ** Start date
      *
 B2  C                   IF        C0MSTD <> *Blanks
     C                   EVAL      DateIn = C0MSTD
     C                   EXSR      ZDate1
      *
 B3  C                   IF        ErrorFlag = 'Y' OR SPMSTD <> DaynoOut
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdStPR
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** Next statement date
      *
 B2  C                   IF        C0NSTD <> *Blanks
     C                   EVAL      DateIn = C0NSTD
     C                   EXSR      ZDate1
      *
 B3  C                   IF        ErrorFlag = 'Y' OR SPNSTD <> DaynoOut
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdStPR
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** Recipient shortname
      *
 B2  C                   IF        SPRECP <> @KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      SPRECP        @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B3  C                   IF        @RtCd <> *Blanks
     C                   EVAL      BBCSSN = *Blanks
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 B2  C                   IF        C0CSSN <> *Blanks AND
     C                             %Scan(%Trim(C0CSSN):BBCSSN) = 0
     C                   EVAL      WRecordOK = 'N'
     C                   GOTO      EndRdStPR
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C     EndRdStPR     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ChkAut - Check for user authority
      *****************************************************************
     C     ChkAut        BEGSR
      *
      ** If not multi-branching
      *
     C                   IF        BJSBRC <> *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** If multi-branching
      *
     C                   ELSE
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM                    ZBR               3
     C                   PARM                    @@ERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDate1 - Convert a date from screen to file format
      *****************************************************************
     C     ZDate1        BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn            6
     C                   PARM                    DaynoOut          5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ErrorFlag         1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTStPR - Format record fields for output
      ******************************************************************
     C     FMTStPR       BEGSR
      *
      ** Date
      *
     C                   Z-ADD     SPDATE        ZDayNo
     C                   EXSR      ZDate2
     C                   MOVEL     ZDATE         S0DATE
      *
      ** Sequence
      *
     C                   MOVE      SPRSEQ        S0RSEQ
      *
      ** Action Code
      *
     C                   EVAL      S0ACTCDE = *Blank
      *
      ** Safekeeping customer
      *
     C                   EVAL      S0CUST = SPCUST
      *
      ** Recipient
      *
     C                   EVAL      S0RECP = SPRECP
      *
      ** Recipient shortname (retrieved in RdStPR above)
      *
     C                   EVAL      S0CSSN = BBCSSN
      *
      ** Statement type
      *
     C                   EVAL      S0TYPE = SPTYPE
      *
      ** Sending branch
      *
     C                   EVAL      S0SNDR = SPSNDR
      *
      ** Start date
      *
     C                   Z-ADD     SPMSTD        ZDayNo
     C                   EXSR      ZDate2
     C                   MOVEL     ZDATE         S0MSTD
      *
      ** Frequency
      *
     C                   EVAL      S0FREQ = SPFREQ
      *
      ** Next statement date
      *
     C                   Z-ADD     SPNSTD        ZDayNo
     C                   EXSR      ZDate2
     C                   MOVEL     ZDATE         S0NSTD
      *
      ** Status (last change type)
      *
     C                   EVAL      S0CHTP = SPCHTP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDate2 - Convert a date from file to screen format
      *****************************************************************
     C     ZDate2        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate             6 0
     C                   PARM                    ZaDate            7
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - Process the last user input or read/validate the next
      *          modified subfile record
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      ** Please note that Idx is always 0 at this point, as, whatever the
      ** case, the routine Screen has always been just performed
      *
      ** F3 or F12: Inform the caller and return
      *
     C                   IF        *INKC OR *INKL
     C                   EVAL      @INKC = *INKC
     C                   EVAL      @INKL = *INKL
     C                   EVAL      TimeToGo = 'Y'
     C                   GOTO      EndRDSFLR
     C                   ENDIF
      *
      ** F5 or change the selection criteria: rebuild the subfile and wait
      ** for another input
      *
     C                   IF        CurrSel <> SavSel OR *INKE
     C   KE              EVAL      CurrSel = SavSel
     C                   EVAL      @BDSFL = 'Y'
     C                   GOTO      EndRDSFLR
     C                   ENDIF
      *
      ** F9: in Insert, it is not possible to use the Retrieve module to
      **     check user's authority, as the sending and originating branches
      **     of the request are not yet known. Thus, the authority will be
      **     checked later, in the Validation module.
      **     So, simply setup the output parameters and return
      *
 B1  C                   IF        *INKI
     C                   EVAL      @OPSEL = 'I'
     C                   CLEAR                   SESTPR
      *
 B2  C                   IF        *IN36                                        Called by program
     C                   EVAL      SPCUST = C0CUST
 E2  C                   ENDIF
      *
     C                   EVAL      TimeToGo = 'Y'
     C                   GOTO      EndRDSFLR
 E1  C                   ENDIF
      *
      ** If there is no subfile, return to the caller
      *
     C                   IF        NOT *IN22
     C                   EVAL      TimeToGo = 'Y'
     C                   GOTO      EndRDSFLR
     C                   ENDIF
      *
      ** If Roll-up pressed, display additional subfile page(s)
      ** and restart this subroutine by using the RPG cycle
      ** (this case can only arise after having displayed a subfile error)
      *
     C                   IF        *IN25
     C                   EXSR      SFPages
     C                   GOTO      EndRDSFLR
     C                   ENDIF
      *
      ** Read the next modified subfile record and validate it.
      ** The screen is re-output at each encountered error.
      ** If all is OK, the output parameters are filled, and
      ** control returns to the caller.
      *
 B1  C                   DOU       %EoF(SESTPRBDF)
      *
     C                   READC     SESTPRBS0
      *
 B2  C                   IF        %EoF(SESTPRBDF)                              No more record
     C                   EVAL      TimeToGo = 'Y'
     C                   LEAVE                                                  --> Quit + return
 E2  C                   ENDIF
      *
 B2  C                   IF        S0ACTCDE = *Blank                            Remove an
     C                   SETOFF                                       4124        eventual
     C                   UPDATE    SESTPRBS0                                      previous error
 X2  C                   ELSE
     C                   EXSR      RtvStPR
      *
 B3  C                   IF        Idx > 0                                      Action code error
     C                   SETON                                        4124      Error + SFLNXTCHG
     C                   UPDATE    SESTPRBS0
     C                   EVAL      C0RRN = @@RRN                                View page with error
     C                   EXSR      Screen
 X3  C                   ELSE                                                   No error
     C                   EVAL      @OPSEL = S0ACTCDE
     C                   EVAL      S0ACTCDE = *Blank
     C                   SETOFF                                       4124
     C                   UPDATE    SESTPRBS0
     C                   EVAL      TimeToGo = 'Y'
 E3  C                   ENDIF
      *
     C                   LEAVE                                                  --> Quit +/- return
 E2  C                   ENDIF
      *
 E1  C                   ENDDO
      *
     C     EndRDSFLR     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RtvStPR - Retrieve the record to process and validate the action code
      *****************************************************************
     C     RtvStPR       BEGSR
      *
      ** In Enquire processing mode, action codes 'A', 'X' and 'D' are not allowed
      *
     C                   IF        *IN04 AND
     C                             (S0ACTCDE = 'A' OR S0ACTCDE = 'X' OR
     C                              S0ACTCDE = 'D')
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx)   = 'APM0200'
     C                   GOTO      EndRtvStPR
     C                   ENDIF
      *
      ** Set up input parameters for the retrieve module
      *
     C                   EVAL      DDACTN = S0ACTCDE
     C                   EVAL      DDDATE = S0DATE
     C                   EVAL      DDRSEQ = S0RSEQ
      *
      ** Call the retrieve module
      *
     C                   CALLB     'SESTPRRTV'
      ** INPUT PARAMETERS
      ** Return code
     C                   PARM                    RetCodeOut
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      *Blanks       ModeofOp          6
      ** Response mode (SPF checking required)
     C                   PARM      'S'           RespMode          1
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Front Office Transaction ID
     C                   PARM      *Blanks       FOTRID           20
      ** (Midas) Statement Production Request Reference
     C                   PARM                    DDStPRRef
      *
      ** OUPUT PARAMETERS
      ** Statement Production Request in file format
     C                   PARM                    SESTPR
      ** OK - Action code and first key field of the request reference
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDDATEOK          1
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
     C     EndRtvStPR    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Clear outputs
      *
     C                   CLEAR                   SESTPR
     C                   EVAL      @OPSEL = *BLANK
     C                   EVAL      @INKC  = '0'
     C                   EVAL      @INKL  = '0'
      *
      ** It is not time to return to the caller
      *
     C                   MOVE      'N'           TimeToGo          1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Processing Mode (E/Enquiry or M/Maintenance)
     C                   PARM                    ProcesMode        1
      ** Build Subfile
     C                   PARM                    @BDSFL            1
      ** Read Subfile Record
     C                   PARM                    @RDSFL            1
      *
      ** INPUT/OUTPUT PARAMETERS
      ** In/out=Request Reference - Out=Request record to process
     C                   PARM                    SESTPR
      *
      ** OUTPUT PARAMETERS
      ** Option Selected
     C                   PARM                    @OPSEL            1
      ** Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Program message queue name
      *
     C                   EVAL      MSPGMQ = '*'
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       @RtCD
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        @RtCd <> *Blanks
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     900           DBASE
     C                   MOVEL     @Optn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access User Details
      *
     C                   CALL      'AOUSERR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      PSUser        @USRP            10
     C     SDUSER        PARM      SDUSER        DSSDY
      *
      ** Database error
      *
     C                   IF        @RtCd <> *Blanks
     C                   MOVEL     'MUSERDD'     DBFILE
     C                   Z-ADD     901           DBASE
     C                   MOVEL     PSUser        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE
      *
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
      *
      ** Set up the transaction reference to be used by the message handler
      ** (Absolutely doesn't matter in our case: the messages are sent to
      ** screen, via the program's message queue)
      *
     C                   EVAL      TranRef = 'Not Used'
     C                   EVAL      ActionCode = '?'
      *
      ** Basic setup of the screen: Enquiry mode or not
      **                            Allow Authorise or not (test routing officer ind)
      *                                                               >><<==
     C     ProcesMode    COMP      'E'                                    04
     C     ROUF          COMP      'Y'                                    01
      *
      ** If at first call, the received record layout contains a Customer
      ** Number or "*PGM", than the Statement Production Requests Maintenance
      ** has been called by another program to work with that given reference.
      ** In this case, allow F12 and, if the reference is a Customer Number,
      ** setup the corresponding selection field and lock it.
      *
 B1  C                   IF        SPCUST <> *Blanks                            Called by Program
     C                   SETON                                        12        Allow F12
      *
 B2  C                   IF        SPCUST <> '*PGM'
     C                   SETON                                        36        Protect Field
 X2  C                   ELSE
     C                   EVAL      SPCUST = *Blanks
 E2  C                   ENDIF
      *
     C                   EVAL      C0CUST = SPCUST
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
