     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statmts Prod. Requests - Browse Invalid')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SESTPRRPB - Statement Production Requests              *
      *                  - Browse Invalid                             *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One displays a list of invalid transactions,      *
      *             the other picks off the selection made.           *
      *                                                               *
      *  Note about authorities checking when multi-branching:        *
      *      .The repair functions (E, N, U and Q) are validated      *
      *       against the user's branch by ZAROPTVAL                  *
      *      .The database functions (A, I, D, X) required by the     *
      *       invalid records are validated against the sending and   *
      *       originating branches of the request by SESTPRRTV        *
      *       (except for insert) or SESTPRVAL (insert only).         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE040  *CREATE    Date 27Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSESTPRRDF CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SESTPRRS0:@@RRN)
      ** Midas SE Statement Production Requests - Browse Invalid Display File
 
     FSEISTPRL0 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SE Statement Production Requests - Invalid by TmSt/FOId
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      ** Table of field numbers and names (dummy use)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       21  SFLDSPCTL if *On / SFLCLR if *Off                   *
      *       22  SFLDSP and Displays Action Codes if *On             *
      *       23  SFLEND if *On                                       *
      *    41-70  Field Error Indicators                              *
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
 
     D InvSESTPR     E DS                  EXTNAME(SEISTPRPD)
      ** Invalid Statement Production Request record layout
 
     D SESTPR        E DS                  EXTNAME(SESTPRPD)
      ** Statement Production Request record layout
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for access programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long DS for access programs
 
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)
      ** Midas ZMUSER Data Area Layout
 
      ** Split up of the Statement Production Request Reference
     D DDStPRRef       DS
      ** -- Main key (used in SIN function)
     D     DDStPRDATE                 6A
     D     DDStPRRSEQ                 7A
     D   DDStPRMainK           1     13A
      ** -- Alternative key (used in CTL & RPR functions)
     D     DDStPRCUST                 6A
     D     DDStPRTYPE                 2A
     D     DDStPRSNDR                 3A
     D     DDStPRRECP                11A
     D     DDStPRFREQ                 1A
     D   DDStPRAltK           14     36A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Timestamp
     D @TMST           S               Z
 
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
      * BLDSFL - Build the subfile and write/read of the screen
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** Clear the subfile and initialise its relative record number
      *
     C                   SETOFF                                       2122
     C                   WRITE     SESTPRRC0
     C                   SETON                                        21
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      ** Check the user authority to browse
      *
     C                   IF        BJSBRC <> *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
     C                   ELSE
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM      DBRN          ZBR               3
     C                   PARM                    @@ERR
     C                   ENDIF
      *
      ** Fill the subfile if authority is Ok
      *
 B1  C                   IF        @@ERR = 0
      *
      ** Set file pointer at the beginning of the invalid file
      *
     C     *LOVAL        SETLL     SEISTPRD0
      *
      ** Read the next invalid request record and validate it for display
      *
     C                   EXSR      RdStPR
      *
      ** Fill the subfile in one loop (no need to handle a rollup indicator
      ** here, as there should be only a few invalid transactions)
      *
      ** No SFLNXTCHG, nor error on Action Code
      *
     C                   SETOFF                                       2441
      *
 B2  C                   DOW       NOT %EoF(SEISTPRL0)
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
     C                   WRITE     SESTPRRS0
 E3  C                   ENDIF
      *
      ** Read the next invalid request record and validate it for display
      *
     C                   EXSR      RdStPR
 E2  C                   ENDDO
      *
 E1  C                   ENDIF
      *
      ** Display the subfile if there is at least one record
      ** Otherwise, send a message "no data to display", or
      **                           "user not authorised..."
      *
 B1  C                   IF        @@RRN > 0
     C                   SETON                                        22
 X1  C                   ELSE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
      *
 B2  C                   IF        @@ERR = 0
     C                   EVAL      MsgIdArr(Idx)   = 'ST00040'
 X2  C                   ELSE
     C                   EVAL      MsgIdArr(Idx)   = 'ST00076'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Set End of Subfile on
      *
     C                   SETON                                        23
      *
      ** Write/Read the screen
      *
     C                   EVAL      C0RRN = 1
     C                   EXSR      Screen
      *
      ** Return to the caller
      *
     C                   EVAL      TimeToGo = 'Y'
      *
     C     EndBLDSFL     ENDSR
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
     C                   WRITE     SESTPRRCM                                    Options+Keys+Msgs
     C                   EXFMT     SESTPRRC0                                    Subfile control
      *
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * RdStPR - Read the next invalid request record and validate it for display
      *****************************************************************
     C     RdStPR        BEGSR
      *
      ** Reset the "record ok" flag
      *
     C                   MOVE      'Y'           WRecordOK         1
      *
      ** Read the next record
      *
     C                   READ (N)  SEISTPRD0
      *
      ** Validate the record for display if not end of file:
      ** .Any invalid record is to be displayed
      *
     C                   IF        NOT %EoF(SEISTPRL0)
      *            --> Nothing to do (for the moment !!!) <--
     C                   ENDIF
      *
     C     EndRdStPR     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTStPR - Format record fields for output
      ******************************************************************
     C     FMTStPR       BEGSR
      *
      ** Timestamp
      *
     C                   EVAL      S0TMESTMP  = DDTMESTMP
      *
      ** Request Date
      *
     C                   EVAL      S0DATE     = DDDATE
      *
      ** Request Sequence
      *
     C                   EVAL      S0RSEQ     = DDRSEQ
      *
      ** Subfile Action Code
      *
     C                   EVAL      S0ACTCDE   = *Blank
      *
      ** Action Code
      *
     C                   EVAL      S0ACTN     = DDACTN
      *
      ** Safekeeping Customer
      *
     C                   EVAL      S0CUST     = DDCUST
      *
      ** Recipient
      *
     C                   EVAL      S0RECP     = DDRECP
      *
      ** Type of Statement
      *
     C                   EVAL      S0TYPE     = DDTYPE
      *
      ** Sending Branch
      *
     C                   EVAL      S0SNDR     = DDSNDR
      *
      ** Midas Start Date
      *
     C                   EVAL      S0MSTD     = DDMSTD
      *
      ** Frequency
      *
     C                   EVAL      S0FREQ     = DDFREQ
      *
      ** Next Statement Date
      *
     C                   EVAL      S0NSTD     = DDNSTD
      *
      ** Front Office Transaction Id
      *
     C                   EVAL      S0FOTRANID = DDFOTRANID
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
      ** F3: Inform the caller and return
      *
     C                   IF        *INKC
     C                   EVAL      @INKC = *INKC
     C                   EVAL      TimeToGo = 'Y'
     C                   GOTO      EndRDSFLR
     C                   ENDIF
      *
      ** F5: rebuild the subfile and wait for another input
      *
     C                   IF        *INKE
     C                   EVAL      @BDSFL = 'Y'
     C                   GOTO      EndRDSFLR
     C                   ENDIF
      *
      ** If there is no subfile, return to the caller
      *
     C                   IF        NOT *IN22
     C                   EVAL      TimeToGo = 'Y'
     C                   GOTO      EndRDSFLR
     C                   ENDIF
      *
      ** Read the next modified subfile record and validate it.
      ** Action Codes "E" and "Q" are processed without return to the caller.
      ** The screen is re-output at each encountered error.
      ** If the action code is not "E" nor "Q" and all is OK, the output
      ** parameters are filled, and control returns to the caller.
      *
 B1  C                   DOU       %EoF(SESTPRRDF)
      *
     C                   READC     SESTPRRS0
      *------------------
 B2  C                   IF        %EoF(SESTPRRDF)                              No more record
     C                   EVAL      TimeToGo = 'Y'
     C                   LEAVE                                                  --> Quit + return
 E2  C                   ENDIF
      *------------------
 B2  C                   IF        S0ACTCDE = *Blank                            Remove an
     C                   SETOFF                                       4124        eventual
     C                   UPDATE    SESTPRRS0                                      previous error
 X2  C                   ELSE
     C                   EXSR      ValidROpt                                    Validate option
      *
 B3  C                   IF        @INKC = '1' OR @INKL = '1'                   F3 or F12
     C                   LEAVE                                                  --> Quit +/- return
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *------------------
 B2  C                   SELECT
      *-----
 X2  C                   WHEN      S0ACTCDE = 'E'                               Enquire invalid
     C                   EXSR      EnqInv
      *
 B3  C                   IF        @INKC = '1' OR @INKL = '1'                   F3 or F12
     C                   LEAVE                                                  --> Quit +/- return
 E3  C                   ENDIF
      *-----
 X2  C                   WHEN      S0ACTCDE = 'Q'                               Delete invalid
     C                   EXSR      DelInv
      *
 B3  C                   IF        @INKC = '1' OR @INKL = '1'                   F3 or F12
     C                   LEAVE                                                  --> Quit +/- return
 E3  C                   ENDIF
      *-----
 X2  C                   WHEN      S0ACTCDE = 'N'                               Repair no changes
     C                   EXSR      ViewRepair
     C                   LEAVE                                                  --> Quit + return
      *-----
 X2  C                   WHEN      S0ACTCDE = 'U'                               Repair + changes
     C                   EXSR      Repair
     C                   LEAVE                                                  --> Quit +/- return
 E2  C                   ENDSL
      *
 E1  C                   ENDDO
      *
     C     EndRDSFLR     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValidROpt - Validate repair option code
      *****************************************************************
     C     ValidROpt     BEGSR
      *
     C                   CALLB     'ZAROPTVAL'
      ** INPUTS PARAMETERS
      ** Return Code
     C                   PARM      *Blanks       RetCodeOut
      ** Option code
      ** Front Office ID
      ** Booking Branch (use user's default when blank)
     C                   PARM                    S0ACTCDE
     C                   PARM                    S0FOTRANID
     C                   PARM      *Blanks       @BRCH             3
      ** ICD Single branch code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT PARAMETERS
      ** Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL             1
      *
      ** If F3, bypass further processing.
      *
     C                   IF        @INKC = '1'
     C                   EVAL      TimeToGo = 'Y'
     C                   ENDIF
      *
      ** If F12, re-display the screen at the page of the current (blanked out) option
      *
     C                   IF        @INKL = '1'
     C                   EVAL      C0RRN = @@RRN
     C                   EVAL      S0ACTCDE = *Blank
     C                   SETOFF                                       4124
     C                   UPDATE    SESTPRRS0
     C                   EXSR      Screen
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EnqInv - Enquire on an invalid record
      *****************************************************************
     C     EnqInv        BEGSR
      *
      ** Pass the invalid transaction details to the enquiry
      *
     C     KSEISTPRL0    CHAIN (N) SEISTPRD0
      *
     C                   CALLB     'ZAINVTRENQ'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM      *Blanks       RetCodeOut
      ** Action code
      ** Front Office ID
      ** Associated Front Office ID
      ** Timestamp
     C                   PARM                    DDACTN
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID
     C                   PARM                    DDTMESTMP
      ** Invalid file names
     C                   PARM      'SEISTPRPD'   InvFile1         10
     C                   PARM      *Blanks       InvFile2         10
     C                   PARM      *Blanks       InvFile3         10
      ** Invalid file data
     C                   PARM      InvSESTPR     InvFDta1       4000
     C                   PARM      *Blanks       InvFDta2       4000
     C                   PARM      *Blanks       InvFDta3       4000
      *
      ** OUTPUT PARAMETERS
      ** Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      ** If F3, bypass further processing.
      *
     C                   IF        @INKC = '1'
     C                   EVAL      TimeToGo = 'Y'
     C                   ENDIF
      *
      ** If F12, re-display the screen at the page of the current (blanked out) option
      *
     C                   IF        @INKL = '1'
     C                   EVAL      C0RRN = @@RRN
     C                   EVAL      S0ACTCDE = *Blank
     C                   SETOFF                                       4124
     C                   UPDATE    SESTPRRS0
     C                   EXSR      Screen
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DelInv - Delete an invalid record
      *****************************************************************
     C     DelInv        BEGSR
      *
      ** Pass the invalid transaction details to the deletion prompt
      *
     C     KSEISTPRL0    CHAIN (N) SEISTPRD0
      *
     C                   CALLB     'ZAINVTRDEL'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM      *Blanks       RetCodeOut
      ** Action code
     C                   PARM                    DDACTN
      ** Front Office Trans ID & Front Office Associated Trans ID
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID
      ** Timestamp
     C                   PARM                    DDTMESTMP
      ** Narrative & Field Content 1 - 9
     C                   PARM                    P@NAR1           30
     C                   PARM      DDACTN        P@FLD1           35
     C                   PARM                    P@NAR2           30
     C                   PARM      DDCUST        P@FLD2           35
     C                   PARM                    P@NAR3           30
     C                   PARM      DDRECP        P@FLD3           35
     C                   PARM                    P@NAR4           30
     C                   PARM      DDTYPE        P@FLD4           35
     C                   PARM                    P@NAR5           30
     C                   PARM      DDSNDR        P@FLD5           35
     C                   PARM                    P@NAR6           30
     C                   PARM      DDMSTD        P@FLD6           35
     C                   PARM                    P@NAR7           30
     C                   PARM      DDFREQ        P@FLD7           35
     C                   PARM                    P@NAR8           30
     C                   PARM      DDNSTD        P@FLD8           35
     C                   PARM                    P@NAR9           30
     C                   PARM      *Blanks       P@FLD9           35
      *
      ** OUTPUT PARAMETERS
      ** Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL
      *
      ** If F3, bypass further processing.
      *
     C                   IF        @INKC = '1'
     C                   EVAL      TimeToGo = 'Y'
     C                   ENDIF
      *
      ** If F12, re-display the screen at the page of the current (blanked out) option
      *
     C                   IF        @INKL = '1'
     C                   EVAL      C0RRN = @@RRN
     C                   EVAL      S0ACTCDE = *Blank
     C                   SETOFF                                       4124
     C                   UPDATE    SESTPRRS0
     C                   EXSR      Screen
     C                   ENDIF
      *
      ** If F10, delete the invalid record and blank out the subfile option
      *
     C                   IF        @INKJ = '1'
     C     KSEISTPRL0    CHAIN     SEISTPRD0                          99
     C  N99              DELETE    SEISTPRD0
     C  N99              COMMIT
     C                   EVAL      S0ACTCDE = *Blank
     C                   SETOFF                                       4124
     C                   UPDATE    SESTPRRS0
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ViewRepair - Setup output parameters for the caller to display
      *              an invalid record in enquiry mode
      *****************************************************************
     C     ViewRepair    BEGSR
      *
      ** Retrieve the current request record (without SPF authority check)
      *
     C                   IF        S0ACTN <> 'I'
     C                   EVAL      RespMode = *Blank
     C                   EXSR      RtvStPR
     C                   ENDIF
      *
      ** Ignore any error messages
      *
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr   = *Blanks
     C                   EVAL      MsgDtaArr  = *Blanks
     C                   MOVE      0             Idx
      *
      ** Setup output parameters
      *
     C                   EVAL      @OPSEL = 'E'
     C                   EVAL      @FOID  = S0FOTRANID
     C                   EVAL      @TMST  = S0TMESTMP
      *
 B1  C                   IF        S0ACTN = 'I'
     C                   CLEAR                   SESTPR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      S0DATE        DateIn            6
     C     SPDATE        PARM                    DaynoOut          5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ErrorFlag         1
      *
 B2  C                   IF        ErrorFlag = 'Y'
     C                   EVAL      SPDATE = 0
 E2  C                   ENDIF
      *
     C                   MOVEL     S0RSEQ        WWTEST8           8
     C                   MOVE      '0'           WWTEST8
     C                   TESTN                   WWTEST8              9999
     C   99              MOVE      S0RSEQ        SPRSEQ
      *
     C                   EVAL      SPCUST = S0CUST
     C                   EVAL      SPTYPE = S0TYPE
     C                   EVAL      SPSNDR = S0SNDR
     C                   EVAL      SPRECP = S0RECP
     C                   EVAL      SPFREQ = S0FREQ
 E1  C                   ENDIF
      *
      ** Blank out the subfile option
      *
     C                   EVAL      S0ACTCDE = *Blank
     C                   SETOFF                                       4124
     C                   UPDATE    SESTPRRS0
      *
      ** Return to the caller
      *
     C                   EVAL      TimeToGo = 'Y'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Repair - Validate the invalid record action code against the
      *          current databse record. Return to the caller if all's Ok
      *****************************************************************
     C     Repair        BEGSR
      *
      ** Validate action code versus the request IDs supplied
      ** The request in file format from the SE database is retrieved
      ** as well.
      ** Note: in Insert, it is not possible to use the Retrieve module to
      **       check user's authority, as the sending and originating branches
      **       of the request are not yet known. Thus, the authority will be
      **       checked later, in the Validation module.
      *
     C                   IF        S0ACTN <> 'I'
     C                   EVAL      RespMode = 'S'
     C                   ELSE
     C                   EVAL      RespMode = *Blank
     C                   ENDIF
      *
     C                   EXSR      RtvStPR
      *
      ** If there are errors, re-output the browse screen in highlighting
      ** the subfile action code
      *
 B1  C                   IF        Idx > 0
     C                   SETON                                        4124
     C                   UPDATE    SESTPRRS0
     C                   EXSR      Screen
      *
      ** Otherwise, setup output parameters, blank out the subfile option
      ** and return to the caller
      *
 X1  C                   ELSE
     C                   EVAL      @OPSEL = S0ACTN
     C                   EVAL      @FOID  = S0FOTRANID
     C                   EVAL      @TMST  = S0TMESTMP
      *
 B2  C                   IF        S0ACTN = 'I'
     C                   CLEAR                   SESTPR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      S0DATE        DateIn
     C     SPDATE        PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
 B3  C                   IF        ErrorFlag = 'Y'
     C                   EVAL      SPDATE = 0
 E3  C                   ENDIF
      *
     C                   MOVEL     S0RSEQ        WWTEST8           8
     C                   MOVE      '0'           WWTEST8
     C                   TESTN                   WWTEST8              9999
     C   99              MOVE      S0RSEQ        SPRSEQ
      *
     C                   EVAL      SPCUST = S0CUST
     C                   EVAL      SPTYPE = S0TYPE
     C                   EVAL      SPSNDR = S0SNDR
     C                   EVAL      SPRECP = S0RECP
     C                   EVAL      SPFREQ = S0FREQ
 E2  C                   ENDIF
      *
     C                   EVAL      S0ACTCDE = *Blank
     C                   SETOFF                                       4124
     C                   UPDATE    SESTPRRS0
      *
     C                   EVAL      TimeToGo = 'Y'
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RtvStPR - Retrieve the current request record to process and
      *           validate the action code
      *****************************************************************
     C     RtvStPR       BEGSR
      *
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas Request Reference is not present
      **  (including a check for the existence of the replacement character
      **   at the Midas Request Reference level).
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas Request Reference).
      *
      **  We assume no substitution has been defined for the transaction ID
      *
     C                   EVAL      DDStPRDATE = S0DATE
     C                   EVAL      DDStPRRSEQ = S0RSEQ
     C                   EVAL      DDStPRCUST = S0CUST
     C                   EVAL      DDStPRTYPE = S0TYPE
     C                   EVAL      DDStPRSNDR = S0SNDR
     C                   EVAL      DDStPRRECP = S0RECP
     C                   EVAL      DDStPRFREQ = S0FREQ
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      S0DATE        DateIn
     C                   PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
 B1  C                   IF        ErrorFlag = 'Y'
     C                   EVAL      DDStPRDATE = *Blanks
 E1  C                   ENDIF
      *
     C                   MOVEL     S0RSEQ        WWTEST8
     C                   MOVE      '0'           WWTEST8
     C                   TESTN                   WWTEST8              9999
     C  N99              EVAL      DDStPRRSEQ = *Blanks
      *
 B1  C                   IF        S0ACTN = 'I'
     C                   EVAL      ModeofOp = '*FRONT'
 X1  C                   ELSE
      *
 B2  C                   IF        (DDStPRDATE = *Blanks OR                     Main key
     C                              DDStPRRSEQ = *Blanks OR                       not present
     C                              %Scan(GHSUBS:DDStPRMainK) > 0)
     C                                          AND                               AND
     C                             (DDStPRCUST = *Blanks OR
     C                              DDStPRTYPE = *Blanks OR                     Alternate Key
     C                              DDStPRSNDR = *Blanks OR                       not present
     C                              DDStPRRECP = *Blanks OR
     C                              DDStPRFREQ = *Blanks OR
     C                              %Scan(GHSUBS:DDStPRAltK) > 0)
     C                   EVAL      ModeofOp = '*FRONT'
 X2  C                   ELSE
     C                   EVAL      ModeofOp = *Blanks
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Call the retrieve module
      *
     C                   CALLB     'SESTPRRTV'
      ** INPUT PARAMETERS
      ** Return code
     C                   PARM                    RetCodeOut
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      ** Response mode (SPF checking required, or not)
     C                   PARM                    RespMode          1
      ** Action Code
     C                   PARM                    S0ACTN            1
      ** Front Office Transaction ID
     C                   PARM      S0FOTRANID    FOTRID           20
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
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Clear outputs
      *
     C                   EVAL      @OPSEL = *BLANK
     C                   EVAL      @FOID  = *BLANK
     C                   CLEAR                   @TMST
     C                   CLEAR                   SESTPR
     C                   EVAL      @INKC  = '0'
      *
      ** It is not time to return to the caller
      *
     C                   MOVE      'N'           TimeToGo          1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RtvTxt - Retrieve text
      *****************************************************************
     C     RtvTxt        BEGSR
      *
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C                   PARM      *BLANK        MSGTXT           80
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
      ** Build Subfile
     C                   PARM                    @BDSFL            1
      ** Read Subfile Record
     C                   PARM                    @RDSFL            1
      *
      ** OUTPUT PARAMETERS
      ** Option Selected
     C                   PARM                    @OPSEL            1
      ** Identification of the Invalid Request to Process
     C                   PARM                    @FOID            20
     C                   PARM                    @TMST
      ** (Current) Request Record to Process
     C                   PARM                    SESTPR
      ** Command Keys
     C                   PARM                    @INKC             1
      *
      ** Klist's
      *
     C     KSEISTPRL0    KLIST
     C                   KFLD                    S0TMESTMP
     C                   KFLD                    S0FOTRANID
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
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'                           ************
     C                   EVAL      DBASE  = 900                                  * DBERR 900*
     C                   EVAL      DBKEY = @Optn                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access API ICD via access program
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DBFILE = 'SDAPIPD'                            ************
     C                   EVAL      DBASE  = 901                                  * DBERR 901*
     C                   EVAL      DBKEY = @Optn                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve the user's default branch (DBRN in ZMUSER)
      *
     C                   IF        BJSBRC = *BLANK
     C                   IN        ZMUSER
     C                   ENDIF
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
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
     C                   EVAL      TranRef = 'Yes, but a bit cold'
     C                   EVAL      ActionCode = '?'
      *
      ** Format text for invalid transaction deletion function
      *
     C                   EVAL      MSGDNB = 'APA3001'
     C                   EXSR      RTVTXT
     C                   EVAL      P@NAR1 = MSGTXT
     C                   EVAL      MSGDNB = 'APA3009'
     C                   EXSR      RTVTXT
     C                   EVAL      P@NAR2 = MSGTXT
     C                   EVAL      MSGDNB = 'APA3010'
     C                   EXSR      RTVTXT
     C                   EVAL      P@NAR3 = MSGTXT
     C                   EVAL      MSGDNB = 'APA3011'
     C                   EXSR      RTVTXT
     C                   EVAL      P@NAR4 = MSGTXT
     C                   EVAL      MSGDNB = 'APA3012'
     C                   EXSR      RTVTXT
     C                   EVAL      P@NAR5 = MSGTXT
     C                   EVAL      MSGDNB = 'APA3013'
     C                   EXSR      RTVTXT
     C                   EVAL      P@NAR6 = MSGTXT
     C                   EVAL      MSGDNB = 'APA3014'
     C                   EXSR      RTVTXT
     C                   EVAL      P@NAR7 = MSGTXT
     C                   EVAL      MSGDNB = 'APA3015'
     C                   EXSR      RTVTXT
     C                   EVAL      P@NAR8 = MSGTXT
     C                   EVAL      P@NAR9 = *Blanks
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
