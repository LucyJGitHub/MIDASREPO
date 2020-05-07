     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details Support Log Setup')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDLOG - Customer Details Support Log Setup               *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             Customer Details file into screen format to be    *
      *             used in writing records to the log file.          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055446           Date 04Apr20               *
      *  Prev Amend No. MD054028           Date 05Sep19               *
      *                 MD046248           Date 27Oct17               *
      *                 CFT050             Date 03Jun13               *
      *                 CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 222373             Date 24Oct03               *
      *                 213051             Date 15Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055446 - There are parties and fields missing from the BRT *
      *             details tab in Customer Input plus date of birth  *
      *             issues.                                           *
      *           - Recompile over changes in SDCBRTPD.               *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT050 - SWIFTRef Directories upload (Recompile)             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  222373 - Parameter Mismatch                                  *
      *  213051 - Parameter for MT3xx not passed to SDCUSDCVT causing *
      *           pointer or parameter error.                         *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************

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

      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

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

      ** Customer Details file
     D CUSDFilFmt    E DS                  EXTNAME(SDCUSTPD)

      ** Midas BRT Customer details
     D BRTXFilFmt    E DS                  EXTNAME(SDCBRTPD)

      ** Midas SD API Customer Private Banking details
     D PRIVFilFmt    E DS                  EXTNAME(SDPBDSPD)
     D                                     PREFIX(O)
                                                                                              CER059
     D TranInACU3    E DS                  EXTNAME (SDACU3DPD)                                CER059
     D TranInACU4    E DS                  EXTNAME (SDACU4DPD)                                CER059

      ** Customer details in Screen Format - Primary Details
     D CUSDScnFmt    E DS                  EXTNAME(SDCUPRPD)

      ** Customer details in Screen Format - Secondary Details
     D CUSEScnFmt    E DS                  EXTNAME(SDCUSEPD)

      ** Customer details in Screen Format - Message Routing Details
     D MSGDScnFmt    E DS                  EXTNAME(SDCUMRPD)

      ** Customer details in Screen Format - Base Rate Tax Details
     D BRTXScnFmt    E DS                  EXTNAME(SDCUBRPD)

      ** Customer details in Screen Format - Private Banking Details
     D PRIVScnFmt    E DS                  EXTNAME(SDCUPBPD)
     D                                     PREFIX(O)

      ** SD Customer details Extra Data - File (D/B) format
     D CUSDExtDta    E DS                  EXTNAME(SDCUEXPD)
                                                                                              213051
      ** Current Customer in Screen Format - MT3xx BEI Details                                213051
     D CuMT3XFmt     E DS                  EXTNAME(SDCUMTPD)                                  213051
                                                                                              222373
      ** Global Customer X-Reference - File Format                                            222373
     D GCustFilFmt   E DS                  EXTNAME(GPCUSTXPD)                                 222373

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D TRANSDTL        S           5800A
     D DDAPRC          S              1A                                                    MD054028

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   EXSR      SRProc

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRProc - Detail Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      *****************************************************************

     C     SRProc        BEGSR

     C                   EVAL      TRANSDTL = *Blanks
     C                   EVAL      DDACTN = BBTYLC

     C                   CALLB     'SDCUSDCVT'
     C                   PARM                    RetCodeOut
     C                   PARM                    CUSDFilFmt
     C                   PARM                    BRTXFilFmt
     C                   PARM                    PRIVFilFmt
     C                   PARM                    TranInACU3                                   CER059
     C                   PARM                    TranInACU4                                   CER059
      *                                                                                     MD054028
     C                   PARM                    DDAPRC                                     MD054028
      ** Global Customer X-Reference                                                          222373
     C                   PARM                    GCustFilFmt                                  222373
     C                   PARM                    CUSDScnFmt
     C                   PARM                    CUSEScnFmt
     C                   PARM                    CuMT3xFmt                                    213051
     C                   PARM                    MSGDScnFmt
     C                   PARM                    BRTXScnFmt
     C                   PARM                    PRIVScnFmt

     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*Error'
     C                   ELSE

     C                   EVAL      TRANSDTL = CUSDScnFmt + CUSEScnFmt
     C                                        + MSGDScnFmt + BRTXScnFmt
     C                                        + PRIVScnFmt + CUSDExtDta
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    CUSDFilFmt
     C                   PARM                    BRTXFilFmt
     C                   PARM                    PRIVFilFmt
     C                   PARM                    TRANSDTL

      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
