     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Write Transactions, Accounts and Position')   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOWRTTRAP - Write Transactions, Accounts and Positions       *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD032884           Date 09Jun15               *
      *                 MD021097           Date 30Sep13               *
      *                 AR802337           Date 22Aug13               *
      *                 CLE148             Date 23Jul12               *
      *                 CAP207             Date 10Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249207             Date 11Aug07               *
      *                 247277             Date 16Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12798           Date 06Dec06               *
      *                 BUG11821           Date 03Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3860            Date 19Aug04               *
      *                 BUG3828            Date 28Jul04               *
      *                 BUG2480            Date 26May04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD032884 - Performance enhancement for GOCXCLTS. Recompiled  *
      *             due to change in GOTRAPPD.                        *
      *  MD021097 - ABC - FT OPAY Reservations not being reversed.    *
      *             Update GPTRAPPD as well even there's no change    *
      *             but reservation ID is not equal to blanks.        *
      *  AR802337 - Use 'QUSRJOBI' in retrieving job name, to improve *
      *             performance of COB Component GOC0040              *
      *             (Child: AR802338)                                 *
      *           - Applied for MD-21981                              *
      *  CLE148 - Alpha Loan Reference                                *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249207 - Records flagged for delete just sitting on GPTRAPPD;*
      *           commit ID is never updated due to BUG12798          *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      *  BUG12798 - Prevent UPDATE if no change on record.            *
      *  BUG11821 - Enable switchability for Country Code (T_CNCD)    *
      *             between Country of Citizenship and Country of     *
      *             Location depending on system value of             *
      *             'UseCtryCitizenship' in GPSVALPD.                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3860 - Update Alpha customer/risk customer, trans ref     *
      *     numeric and alpha, account code and sequence numeric      *
      *  BUG3828 - Do not blank out resevation id on updates          *
      *  BUG2480 - Send the reservation id to the back end            *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPTRAPL0  UF A E           K DISK    INFSR(*PSSR) USROPN  COMMIT(D_COM)
     F                                     RENAME(GOTRAPD0:GPTRAPD0)
     F                                     PREFIX(G)
     FGOTRAPPD  O    E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D***/COPY*ZACPYSRC,PSDS*************************************                   BUG2480 AR802337
                                                                                            AR802337
      ** Comment out PSDS, use QUSRJOBI instead                                             AR802337
                                                                                            AR802337
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
     D GT_TRAP       E DS                  EXTNAME(GPTRAPPD)
     D                                     PREFIX(G)
 
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Reservation ID dataarea                                                BUG2480
     D GPRESERVID      DS            15                                         BUG2480
     D  ReservID               1     15                                         BUG2480
                                                                                BUG2480
      ** Parameters for QUSROBJD                                                BUG2480
     D ERROR           DS                                                       BUG2480
     D MSGID                   9     15                                         BUG2480
     D REC             S            100                                         BUG2480
     D RECLEN          S              4B 0 INZ(100)                             BUG2480
 
      *                                                                                     AR802337
      ** Parameters for QUSRJOBI                                                            AR802337
      *                                                                                     AR802337
     D JOBINFO         DS            50                                                     AR802337
     D  JobName                9     18                                                     AR802337
     D  JobUser               19     28                                                     AR802337
     D  JobNo                 29     34                                                     AR802337
     D  JobInt                35     50                                                     AR802337
      *                                                                                     AR802337
      ** Program Variables                                                                  BUG12798
     D WUpdate         S              1    INZ('Y')                                         BUG12798
                                                                                            BUG12798
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
 
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#LOC             4
     C                   PARM                    I#CUSTDEFLT       1
     C                   PARM                    T_TRAP
                                                                                BUG2480
     C                   IF        I#LOC = 'GLOB' AND APTRANVU = 'Y'            BUG2480
                                                                                BUG2480
      * Check if reservation id dataarea exists                                 BUG2480
     C                   EVAL      LIB='GPRESERVID'+'QTEMP     '                BUG2480
                                                                                BUG2480
     C                   CALL      'QUSROBJD'                                   BUG2480
     C                   PARM                    REC                            BUG2480
     C                   PARM                    RECLEN                         BUG2480
     C                   PARM      'OBJD0100'    FILFORM           8            BUG2480
     C                   PARM                    LIB              20            BUG2480
     C                   PARM      '*DTAARA   '  OBJTYP           10            BUG2480
     C                   PARM                    ERROR                          BUG2480
                                                                                BUG2480
      * If dataarea exists, read in the contents                                BUG2480
     C                   IF        MSGID = *BLANKS                              BUG2480
     C     *DTAARA       DEFINE                  GPRESERVID                     BUG2480
     C                   IN        GPRESERVID                                   BUG2480
     C                   ELSE                                                   BUG2480
     C                   EVAL      ReservID = *BLANKS                           BUG2480
     C                   ENDIF                                                  BUG2480
     C                   ENDIF                                                  BUG2480
 
      * Supply customer defaults (if required)
 
     C     I#CUSTDEFLT   IFEQ      'Y'
     C                   EXSR      CUST_DEFAULT
     C                   ENDIF
      * Update alpha customer and risk customer                                              BUG3860
     C                   MOVE      T_CNUM        T_CNMA                                      BUG3860
     C                   MOVE      T_RCST        T_RCSA                                      BUG3860
      * Update Account Code,Account Sequence, Transaction ref                                BUG3860
     C                   MOVEL     T_ACOD        T_ACDN                                      BUG3860
     C                   MOVEL     T_ACSQ        T_ACSN                                      BUG3860
     C                   IF        T_MOD <> 'LE'                                              CLE148
     C                   MOVEL     T_TREF        T_TR6N                                      BUG3860
     C                   ENDIF                                                                CLE148
     C                   MOVEL     T_TREF        T_TR6A                                      BUG3860
 
      * Update is either global or zonal. The latter arises in a COB.
 
     C     I#LOC         IFEQ      'GLOB'
     C                   CLEAR                   GT_TRAP                                    BUG12798
     C     GPTRAPK       CHAIN     GPTRAPD0                           99
     C**N99GT_UNUM       ADD       1             T_UNUM                                     BUG12798
     C**N99*****         EVAL      T_RSID  = GT_RSID                                BUG3828 BUG12798
                                                                                            BUG12798
     C                   IF        *IN99   = *OFF                                           BUG12798
     C                   EVAL      WUpdate = 'N'                                            BUG12798
     C                   EVAL      T_RSID  = GT_RSID                                        BUG12798
     C                   EVAL      T_UNUM  = GT_UNUM                                        BUG12798
     C*******************EVAL      T_CCID  = GT_CCID                                 BUG12798 249207
     C                   ENDIF                                                              BUG12798
                                                                                            BUG12798
     C                   IF        GT_TRAP <> T_TRAP                                        BUG12798
     C                             OR ReservID <> *BLANKS                                   MD021097
     C                   EVAL      WUpdate = 'Y'                                            BUG12798
     C                   EVAL      GT_TRAP = T_TRAP
                                                                                BUG2480
     C                   IF        ReservID <> *BLANKS                          BUG2480
     C                   MOVE      *BLANKS       ZFIELD                         BUG2480
     C                   MOVEL     ReservID      ZFIELD                         BUG2480
     C                   Z-ADD     0             ZADEC                          BUG2480
     C                   Z-ADD     15            ZADIG                          BUG2480
     C                   CALLB     'ZALIGN2'                                    BUG2480
     C                   PARM      'Y'           ZALIGNok          1            BUG2480
     C                   PARM                    ZFIELD           16            BUG2480
     C                   PARM                    ZADEC             2 0          BUG2480
     C                   PARM                    ZADIG             2 0          BUG2480
     C                   MOVE      ZFIELD        GT_RSID                        BUG2480
     C                   ENDIF                                                  BUG2480
                                                                                BUG2480
     C                   ENDIF                                                              BUG12798
     C     *IN99         IFEQ      *OFF
     C                   IF        WUpdate = 'Y'                                            BUG12798
     C                   IF        GT_UNUM = 9                                              BUG12798
     C                   EVAL      GT_UNUM = 0                                              BUG12798
     C                   ELSE                                                               BUG12798
     C                   EVAL      GT_UNUM = GT_UNUM + 1                                    BUG12798
     C                   ENDIF                                                              BUG12798
     C                   UPDATE    GPTRAPD0
     C                   ENDIF                                                              BUG12798
     C                   ELSE
     C                   WRITE     GPTRAPD0
     C                   ENDIF
     C                   ELSE
     C                   EVAL      T_GCOB = 'Y'
     C                   WRITE     GOTRAPD0
     C                   ENDIF
 
      * RETURN
 
     C                   RETURN
      /SPACE 5
      ********************************************************************
      * Customer Defaults
      ********************************************************************
     C     CUST_DEFAULT  BEGSR
 
      ** Get customer details
 
     C                   MOVEL     T_CNUM        @KEY1
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     @KYST         OREQ      '*ERROR'
     C                   CLEAR                   SDCUST
     C                   ENDIF
      * Customer branch
     C                   MOVEL     BBBRCD        T_CUBR
 
      ** Get risk customer details
 
     C     T_CNUM        IFNE      T_RCST
     C                   MOVEL     T_RCST        @KEY1
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     @KYST         OREQ      '*ERROR'
     C                   CLEAR                   SDCUST
     C                   ENDIF
     C                   ENDIF
      * Local Industry Code
     C                   MOVEL     BBLICD        T_LICD
      * Country Code
      * -------------                                                                       BUG11821
      ** Retrieve the system value setting to determine if                                  BUG11821
      ** Country of Location or Country of Citizenship is to be                             BUG11821
      ** used here.                                                                         BUG11821
     C                   EXSR      CTRY_SYSVAL                                              BUG11821
      *                                                                                     BUG11821
      ** If system value UseCtryCitizenship = 'Y' then use                                  BUG11821
      ** Country of Citizenship, otherwise use Country of Location.                         BUG11821
      *                                                                                     BUG11821
     C     W#UCC         IFEQ      'Y'                                                      BUG11821
     C                   MOVEL     BBCNCZ        T_CNCD                                     BUG11821
     C                   ELSE                                                               BUG11821
     C                   MOVEL     BBCOLC        T_CNCD
     C                   ENDIF                                                              BUG11821
      *                                                                                     BUG11821
      * Risk Customer branch
     C                   MOVEL     BBBRCD        T_RCBR
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                              BUG11821
      ********************************************************************                  BUG11821
      * Get system value to use for Country Code (i.e. use Country of                       BUG11821
      * Location or Country of Citizenship)                                                 BUG11821
      ********************************************************************                  BUG11821
     C     CTRY_SYSVAL   BEGSR                                                              BUG11821
      *                                                                                     BUG11821
     C                   EVAL      P@RTCD = *BLANKS                                         BUG11821
     C                   EVAL      P@OP01 = 'UseCtryCitizenship'                            BUG11821
      *                                                                                     BUG11821
     C                   CALL      'GPAOSVALR0'                                             BUG11821
     C                   PARM      *BLANK        P@RTCD            7                        BUG11821
     C                   PARM                    P@OP01           20                        BUG11821
     C                   PARM                    P@VL01          200                        BUG11821
     C                   PARM                    P@OP02           20                        BUG11821
     C                   PARM                    P@VL02          200                        BUG11821
     C                   PARM                    P@OP03           20                        BUG11821
     C                   PARM                    P@VL03          200                        BUG11821
     C                   PARM                    P@OP04           20                        BUG11821
     C                   PARM                    P@VL04          200                        BUG11821
     C                   PARM                    P@OP05           20                        BUG11821
     C                   PARM                    P@VL05          200                        BUG11821
     C                   PARM                    P@OP06           20                        BUG11821
     C                   PARM                    P@VL06          200                        BUG11821
     C                   PARM                    P@OP07           20                        BUG11821
     C                   PARM                    P@VL07          200                        BUG11821
     C                   PARM                    P@OP08           20                        BUG11821
     C                   PARM                    P@VL08          200                        BUG11821
     C                   PARM                    P@OP09           20                        BUG11821
     C                   PARM                    P@VL09          200                        BUG11821
     C                   PARM                    P@OP10           20                        BUG11821
     C                   PARM                    P@VL10          200                        BUG11821
      *                                                                                     BUG11821
      ** Extract the system value                                                           BUG11821
      *                                                                                     BUG11821
     C                   MOVEL     'N'           W#UCC             1                        BUG11821
      *                                                                                     BUG11821
     C     P@RTCD        IFEQ      *BLANK                                                   BUG11821
     C                   MOVEL     P@VL01        W#UCC                                      BUG11821
      *                                                                                     BUG11821
      ** Error                                                                              BUG11821
     C                   ELSE                                                               BUG11821
     C                   EVAL      I#ERMS = 'MISSING GLOBAL SYSTEM VALUE'                   BUG11821
     C                   EXSR      *PSSR                                                    BUG11821
     C                   ENDIF                                                              BUG11821
      *                                                                                     BUG11821
     C                   ENDSR                                                              BUG11821
      ********************************************************************                  BUG11821
      /SPACE 5
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
O
O     * Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
 
      * Open file
 
     C     I#LOC         IFEQ      'GLOB'
     C                   OPEN      GPTRAPL0
     C                   ELSE
     C                   OPEN      GOTRAPPD
     C                   ENDIF
                                                                                            AR802337
      ** Use QUSRJOBI to retrieve  Jobname instead of PSDS                                  AR802337
                                                                                            AR802337
     C                   CALL      'QUSRJOBI'                                               AR802337
     C                   PARM      *BLANKS       JOBINFO                                    AR802337
     C                   PARM      50            LENG              4 0                      AR802337
     C                   PARM      'JOBI0100'    INPT              8                        AR802337
     C                   PARM      '*'           QUAL             26                        AR802337
     C                   PARM      *BLANKS       INTR             16                        AR802337
      *                                                                                     AR802337
                                                                                BUG2480
      * Check if this is running in a websphere job                             BUG2480
     C**********         IF        PSJobName = 'QZDASOINIT'                         BUG2480 AR802337
     C**********                   OR PSJobName = 'QSQSRVR'                          247277 AR802337
     C**********                   OR PSJobName = 'GLC445'                           CAP207 AR802337
     C                   IF        JobName   = 'QZDASOINIT'                                 AR802337
     C                             OR JobName   = 'QSQSRVR'                                 AR802337
     C                             OR JobName   = 'GLC445'                                  AR802337
     C                   MOVE      'Y'           APTRANVU          1            BUG2480
     C                   ELSE                                                   BUG2480
     C                   MOVE      *BLANKS       APTRANVU                       BUG2480
     C                   ENDIF                                                  BUG2480
                                                                                BUG2480
 
      * Key list
 
     C     GPTRAPK       KLIST
     C                   KFLD                    T_ID
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
      /SPACE 5
**  CPY@
(c) Finastra International Limited 2003
