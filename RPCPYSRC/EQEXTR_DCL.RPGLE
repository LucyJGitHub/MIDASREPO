      /if defined(EQEXTR_DCL_Inc)
      /eof
      * --------------------------------------------------------------------
      * These compiler directives prevent this member being
      * included if it has already been included.
      * --------------------------------------------------------------------
      /else
      /define EQEXTR_DCL_Inc
      /endif

      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  EQEXTR_DCL - Declares for Equation Generic Extracts          *
      *                                                               *
      *  Function:  This member contains declares for assorted        *
      *  generic extract functions for Equation.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 182523             Date 11Aug00               *
      *  Last Amend No. CRP009  *CREATE    Date 20Apr00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  182523 - Term Deals should have the V5PF details.  DS added. *
      *  CRP009 - Equation Generic Extracts                           *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

      * --------------------------------------------------------------------
      * Includes that are needed by the declares (note that these
      * are protected from repeated inclusions by the use of compiler
      * directives).
      * --------------------------------------------------------------------

      * The following /COPY contains various standard declares
      /COPY RPCPYSRC,Std_Dcl

      * The following /COPY contains the layout of the Meridian header as
      * a data structure
      /COPY RPCPYSRC,Mdn_Hd_DS

      * --------------------------------------------------------------------

      * --------------------------------------------------------------------
      * Named constants
      * --------------------------------------------------------------------

      * The repeating-group separator string for Meridian
     D RepeatSeparator...
     D                 C                   '#ENDOFBLOCK#'

      * The length of data at the start of a message before the actual
      * transaction data starts.
     D CtlInfoLength...
     D                 C                   20

      * --------------------------------------------------------------------
      * Record lengths for expanded formats
      * -----------------------------------
     D GFPF_ExpandedLength...
     D                 C                   336

     D SX20LF_ExpandedLength...
     D                 C                   322

     D OB10LF_ExpandedLength...
     D                 C                   178

     D OSPF_ExpandedLength...
     D                 C                   208

     D OX10LF_ExpandedLength...
     D                 C                   218

     D OT10LF_ExpandedLength...
     D                 C                   79

     D OM10LF_ExpandedLength...
     D                 C                   147

     D LD10LF_ExpandedLength...
     D                 C                   131

     D NE10LF_ExpandedLength...
     D                 C                   33

     D SCPF_ExpandedLength...
     D                 C                   576

     D SR10LF_ExpandedLength...
     D                 C                   337

     D GF03LF_ExpandedLength...
     D                 C                   336

     D S510LF_ExpandedLength...
     D                 C                   702

     D V520LF_ExpandedLength...
     D                 C                   468

     D V510LF_ExpandedLength...                                                 182523
     D                 C                   468                                  182523

     D RJ10LF_ExpandedLength...
     D                 C                   262

     D RK10LF_ExpandedLength...
     D                 C                   42

     D RL10LF_ExpandedLength...
     D                 C                   162

     D SVPF_ExpandedLength...
     D                 C                   321

     D MCPF_ExpandedLength...
     D                 C                   738

     D MD01LF_ExpandedLength...
     D                 C                   435

     D NS01LF_ExpandedLength...
     D                 C                   1022

     D SAPF_ExpandedLength...
     D                 C                   134

     D GJ02LF_ExpandedLength...
     D                 C                   157

     D SGPF_ExpandedLength...
     D                 C                   185

     D PO10lf_ExpandedLength...
     D                 C                   60

     D VA10LF_ExpandedLength...
     D                 C                   69

     D GVPF_ExpandedLength...
     D                 C                   322

     D FV10LF_ExpandedLength...
     D                 C                   423


      * --------------------------------------------------------------------
      * Basic deal types
      * ----------------
     D FXBasicDealType...
     D                 C                   'X'

     D TermBasicDealType...
     D                 C                   'T'

     D NonDealBasicDealType...
     D                 C                   'M'

     D PROCERR         C                   'Error'
     D PROCNRF         C                   'NRF'

      * --------------------------------------------------------------------
      * Message type key values
      * -----------------------

     D CustAddressMessageType...
     D                 C                   'CUSTADD'

     D SSIMessageType...
     D                 C                   'STANDSETT'

     D MSDealType      C                   'MARKETSEC'

     D FXMessageType   C                   'FXDEAL'

     D TermMessageType...
     D                 C                   'TERMDEAL'

     D FRAMessageType...
     D                 C                   'FRADEAL'

     D IRSMessageType...
     D                 C                   'IRSDEAL'

     D PostingMessageType...
     D                 C                   'POSTING'

     D AccountMessageType...
     D                 C                   'ACCOUNT'


      * --------------------------------------------------------------------
      * Declared variables
      * --------------------------------------------------------------------

      *   Composite Data
     D CompData        S                   LIKE(TransData)

      *   Parameters for ProcFormat
     D   InData        S                   LIKE(TransData) INZ(*BLANKS)
     D   InDBFile      S             10A   INZ(*BLANKS)

      * The length of the CompData field which has been used for data
     D CompDataUsedLength...
     D                 S             10I 0

      * --------------------------------------------------------------------
      * Data structures
      * --------------------------------------------------------------------

     D DealTypeDS    E DS                  extname(OBPF)
     D FXDealDS      E DS                  extname(OXPF)
     D TermDealDS    E DS                  extname(OTPF)
     D FRADealDS     E DS                  extname(POPF)
     D IRSDealDS     E DS                  extname(VAPF)
     D MovementDS    E DS                  extname(OMPF)
     D DrawdownDS    E DS                  extname(LDPF)
     D IntStatDealDS E DS                  extname(V5PF)                        182523
     D ExtAccNoDS    E DS                  extname(NEPF)
     D AveBalStatsDS E DS                  extname(SRPF)

      * --------------------------------------------------------------------
      * Procedure prototypes
      * --------------------------------------------------------------------

      * --------------------------------------------------------------------
      * The RPEOSPF procedure (Basic Deals (OSPF) extract)
      * --------------------------------------------------
     D RPEOSPF         PR                  extpgm('RPEOSPF')
     D   OutQueue                          like(MQSQueue)
      *            MQSeries queue to write to
     D   MeridianHead                      like(MdnHeadDS)
      *            Meridian header
     D   TransactData                      like(TransData)
      *            Transaction Data
     D   CommitFlag                        like(CommitCtl)
      *            Commitment control flag
     D   Return                            like(Returncode)
      *            Return Code

      * --------------------------------------------------------------------
      * The RPESCPF procedure (Accounts (SCPF) extract)
      * --------------------------------------------------
     D RPESCPF         PR                  extpgm('RPESCPF')
     D   OutQueue                          like(MQSQueue)
      *            MQSeries queue to write to
     D   MeridianHead                      like(MdnHeadDS)
      *            Meridian header
     D   TransactData                      like(TransData)
      *            Transaction Data
     D   CommitFlag                        like(CommitCtl)
      *            Commitment control flag
     D   Return                            like(Returncode)
      *            Return Code

      * --------------------------------------------------------------------
      * The RPEMCPF procedure (MS Deals (MCPF) extract)
      * --------------------------------------------------
     D RPEMCPF         PR                  extpgm('RPEMCPF')
     D   OutQueue                          like(MQSQueue)
      *            MQSeries queue to write to
     D   MeridianHead                      like(MdnHeadDS)
      *            Meridian header
     D   TransactData                      like(TransData)
      *            Transaction Data
     D   CommitFlag                        like(CommitCtl)
      *            Commitment control flag
     D   Return                            like(Returncode)
      *            Return Code

      * --------------------------------------------------------------------
      * The RPESAPF procedure (Postings (SAPF) extract)
      * --------------------------------------------------
     D RPESAPF         PR                  extpgm('RPESAPF')
     D   OutQueue                          like(MQSQueue)
      *            MQSeries queue to write to
     D   MeridianHead                      like(MdnHeadDS)
      *            Meridian header
     D   TransactData                      like(TransData)
      *            Transaction Data
     D   CommitFlag                        like(CommitCtl)
      *            Commitment control flag
     D   Return                            like(Returncode)
      *            Return Code

      * --------------------------------------------------------------------
      * The RPGVAPF procedure (Standing settlement instructions (GPF) extract)
      * ----------------------------------------------------------------------
     D RPEGVPF         PR                  extpgm('RPEGVPF')
     D   OutQueue                          like(MQSQueue)
      *            MQSeries queue to write to
     D   MeridianHead                      like(MdnHeadDS)
      *            Meridian header
     D   TransactData                      like(TransData)
      *            Transaction Data
     D   CommitFlag                        like(CommitCtl)
      *            Commitment control flag
     D   Return                            like(Returncode)
      *            Return Code


      * --------------------------------------------------------------------
      * The GetDealType procedure
      * -------------------------
      * This procedure receives a deal type and returns a data structure
      * containing the OBPF record for that deal type, or an error code.
     D GetDealType     PR                  like(DealTypeDS)
     D   DealType                     3A   value

      * --------------------------------------------------------------------
      * The GetFXDeal procedure
      * -----------------------
      * This procedure receives the key fields for an FX deal,
      * and returns a data stucture
      * containing the OXPF record for that deal, or an error code.
     D GetFXDeal       PR                  like(FXDealDS)
     D BranchMnemonic                      like(OXBRNM) value
     D DealType                            like(OXDLP) value
     D DealRef                             like(OXDLR) value

      * --------------------------------------------------------------------
      * The GetTermDeal procedure
      * -------------------------
      * This procedure receives the key fields for a Term deal,
      * and returns a data stucture
      * containing the OTPF record for that deal, or an error code.
     D GetTermDeal     PR                  like(TermDealDS)
     D BranchMnemonic                      like(OTBRNM) value
     D DealType                            like(OTDLP) value
     D DealRef                             like(OTDLR) value

      * --------------------------------------------------------------------
      * The GetFRADeal procedure
      * ------------------------
      * This procedure receives the key fields for an FRA deal,
      * and returns a data stucture
      * containing the POPF record for that deal, or an error code.
     D GetFRADeal      PR                  like(FRADealDS)
     D BranchMnemonic                      like(POBRNM) value
     D DealType                            like(PODLP) value
     D DealRef                             like(PODLR) value

      * --------------------------------------------------------------------
      * The GetIRSDeal procedure
      * ------------------------
      * This procedure receives the key fields for an IRS deal,
      * and returns a data stucture
      * containing the VAPF record for that deal, or an error code.
     D GetIRSDeal      PR                  like(IRSDealDS)
     D BranchMnemonic                      like(VABRNM) value
     D DealType                            like(VADLP) value
     D DealRef                             like(VADLR) value

      * --------------------------------------------------------------------
      * The GetMovement procedure
      * -------------------------
      * This procedure receives the deal-specific key fields for a movement,
      * and returns a data stucture containing the
      * next OMPF record for that deal, or an error code.
     D GetMovement     PR                  like(MovementDS)
     D BranchMnemonic                      like(OMBRNM) value
     D DealType                            like(OMDLP) value
     D DealReference                       like(OMDLR) value

      * --------------------------------------------------------------------    182523
      * The GetIntStatDeal procedure                                            182523
      * ----------------------------                                            182523
      * This procedure receives the key fields for a Deal Interest Status       182523
      * record, and returns a data stucture                                     182523
      * containing the V5PF record for that deal, or an error code.             182523
     D GetIntStatDeal  PR                  like(IntStatDealDS)                  182523
     D BranchMnemonic                      like(V5BRNM) value                   182523
     D DealType                            like(V5DLP) value                    182523
     D DealRef                             like(V5DLR) value                    182523
                                                                                182523
      * --------------------------------------------------------------------
      * The GetDrawdown procedure
      * -------------------------
      * This procedure receives the key fields for a Drawdown,
      * and returns a data stucture
      * containing the LDPF record for that deal, or an error code.
     D GetDrawdown     PR                  like(DrawdownDS)
     D BranchMnemonic                      like(LDBRNM) value
     D DealType                            like(LDDLP) value
     D DealRef                             like(LDDLR) value

      * --------------------------------------------------------------------
      * The GetExtAccno procedure
      * -------------------------
     D GetExtAccNo     PR                  like(ExtAccNoDS)
     D AccountBranch                       like(NEAB) value
     D BasicAccountNo                      like(NEAN) value
     D AccountSuffix                       like(NEAS) value

      * --------------------------------------------------------------------
      * The GetMessageType procedure
      * ----------------------------
     D GetMessageType  PR            32A
     D  MessageTypeKey...
     D                               10A   const

