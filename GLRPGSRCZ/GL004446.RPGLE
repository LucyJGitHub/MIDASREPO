     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Ret. Acc. Proj. Mov. upd from Jour. Entry')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL004446 - Retail Account Projected Movements update from    *
      *             Journal Entry                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *
      *  Last Amend No. MD023889           Date 10Dic13               *
      *  Prev Amend No. CGL135B            Date 04Nov13               *
      *                 AR1093096          Date 30Sep13               *
      *                 CAP207             Date 10Feb11               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 08Mar10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 CAP084             Date 03Oct03               *
      *                 CDE005             Date 09Oct02               *
      *                 CGL016  *CREATE    Date 01Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD023889 - Accounting Rules Process (GL Account creation)    *
      *            Added hook: CGL135_111                             *
      *  CGL135B - Accounting Rules Process                           *
      *            Added hooks: CGL135_100, CGL135_101, CGL135_102,   *
      *                         CGL135_103, CGL135_104, CGL135_105,   *
      *                         CGL135_106, CGL135_107                *
      *  AR1093096 - ABC - Reservations not removed for JRNE          *
      *              (Child: AR1093097) (Recompile)                   *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  CAP084 - Recompile due to zone field on GLJENPPD             *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CGL016 - Projected Movements Update Prior to Authorisation   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FPRONO     UF   E           K DISK
     F                                     COMMIT
      *
     FRSACMTPD  O    E             DISK
     F                                     COMMIT
     F/COPY OFCPYSRCZ,CGL135_100                                                             CGL135B
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D ZHC             S              3    DIM(50)                              ZDATES SR.ARRAY
      *
      *     Accept Prono balances & dates into arrays
     D                 DS
     D  PNB                    1     40
     D  PRB                    1     40P 0
     D                                     DIM(5)                               PROJ. NOSTRO BALS
     D  PND                   41     55
     D  PRD                   41     55P 0
     D                                     DIM(5) ASCEND                        PRONO BAL. DATES
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
      *
      ** File structure for write to file
     D I#RSAC        E DS                  EXTNAME(RSACMTPD)
     D  RSBRCA       E                     EXTFLD(BRCA)
     D**W#ACID*                1     18                                                       CGL029
      *
     D RUNDAT          DS            13
     D  EJNB                   8     10P 0
      *
      *     Prono key for error reporting
     D PROERR          DS
     D  KCCY                   1      3
     D  KNNO                   4      5  0
      *
     D DSMEMS        E DS                  EXTNAME(MEMOS)                                     222373
     D                                     PREFIX(M)                                          222373
      *
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * FIRST DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * TRADING DETAILS ACCESSED VIA ACCESS PROGRAM
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      *
     D MMOD          E DS                  EXTNAME(MMODF)
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  LLCD         E                     EXTFLD(LCD)
      *
      *  Currency Codes DS for assigning data from Access
     D D@CURR        E DS                  EXTNAME(SDCURRPD)
      *
      *  Currency Codes DS for assigning data from Access
     D*D@JENP***     E DS                  EXTNAME(GLJENPPD)                                  CGL029
     D D@JENP        E DS                  EXTNAME(GLJENPL0)                                  CGL029
      *
      *  Account Details DS for assigning data from Access
     D D@ACCT        E DS                  EXTNAME(ACCNTAB)
     D  ZZ002B       E                     EXTFLD(ZZ002)
      *
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      * Transaction number data structure for RSACMTPD
     D WTRNM           DS
     D  WBNUM                  1      3
     D  WBINB                  4      6
      *
      /COPY ZSRSRC,ZHOLILE
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D UUACNO          S             10                                                       CGL029
     D W0ACCD          S             10  0                                                    CGL029
     D T#TREF          S             26                                                       CGL029
     D P@ACCD          S             10                                                       CGL029
     D WKFLD9          S              9                                                       CGL029
     D WKFLD12         S             12                                                       CGL029
     D W#ACID          S             24                                                       CGL029
                                                                                              CSC022
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
     D PSARD           S                   LIKE(SARN)                                         CSC022
     D/COPY WNCPYSRC,GLH00473
     D CAP205          S              1A                                                      CAP205
     D/COPY OFCPYSRCZ,CGL135_101                                                             CGL135B
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *     Transaction processing
      *
     C                   EXSR      TRANSR
      *
     C                   MOVE      '1'           *INLR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *     TRANSR SR     SUB-ROUTINE                                    *
      *                                                                  *
      *     Transaction processing                                       *
      *                                                                  *
      ********************************************************************
      *
     C     TRANSR        BEGSR
      *
      *     Process records that have not been shadow posted
      *
      **  Obtain Spot Trade Account Code of the system
      *
     C                   CALL      'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      '015'         DBASE                          ***************
     C                   MOVEL     '*FIRST '     DBOPTN            7            * DB ERROR 15 *
     C                   MOVEL     '*FIRST '     DBKEY                          ***************
     C                   MOVEL     'SDTRADPD'    DBFILE
     C                   MOVEL     @RTCD         W0RTCD
     C                   EXSR      ERRSR
     C                   END
      *
     C                   MOVE      *BLANKS       WKRETL            1            Retail a/c n/f
     C                   MOVE      *BLANKS       WKNOST            1            Nostro a/c n/f
      *
      *  Access Currency codes file for the 'In' currency flag
      *
     C     CEU013        IFEQ      'Y'
     C     WKCYCD        IFNE      BTCYCD
     C                   MOVEL     BTCYCD        UUCYCD
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       UUAPRC            7            B:Return Cd
     C                   PARM      '*KEY'        UUAPOP            7            I:Option
     C                   PARM                    UUCYCD            3            I:Currency Code
     C     D@CURR        PARM      *BLANK        DSSDY                          O:Format
      *
     C     UUAPRC        IFNE      *BLANKS                                      *IF
     C                   MOVE      '017'         DBASE                          ***************
     C                   MOVEL     '*KEY   '     DBOPTN            7            * DB ERROR 17 *
     C                   MOVEL     BTCYCD        DBKEY                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     UUAPRC        W0RTCD
     C                   EXSR      ERRSR
     C                   ELSE
      * Assign work field to file field values.
     C                   MOVEL     A6INCY        WKINCY
     C                   ENDIF
     C                   MOVE      BTCYCD        WKCYCD
     C                   ENDIF
     C                   ENDIF
      *
      *  Access Account master file for 'Closed' accounts and
      *    unopened accounts.
      *
     C     CEU013        IFEQ      'Y'
     C     WKINCY        ANDEQ     'Y'
     C     BTNNBI        IFNE      *BLANKS
      * Check Account Number. - Standard functions  *
      *
      * Set up Parameters for call to AOACCTR0
      *
     C                   MOVEL     *BLANK        UUACID
     C                   MOVEL     BTCUST        UUCUST
     C                   MOVEL     BTCYCD        UUCYCD
     C                   MOVEL     BTACCD        UUACNO
     C                   MOVEL     BTACSN        UUACSN
     C                   MOVEL     BTIBCA        UUBRCD
      *
      *  Call to Access Program - AOACCTR0 Check Account Number
      *  Access Account Details file for the file fields
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       UUAPRC            7            B:Return Cd
     C                   PARM      '*KEY'        UUAPOP            7            B:Option
     C                   PARM                    UUACID           10            I:Account Ident
     C                   PARM                    UUCUST            6            I:Customer Numb
     C                   PARM                    UUCYCD            3            I:Currency Code
     C**********         PARM                    UUACNO            4            I:Account Cod CGL029
     C                   PARM                    UUACNO                                       CGL029
     C                   PARM                    UUACSN            2            I:Account Seque
     C                   PARM                    UUBRCD            3            I:Branch code
     C     D@ACCT        PARM      *BLANK        DSSDY                          O:Format
      *
     C     UUAPRC        IFEQ      '*NRF'                                       Not found
     C     ACST          OREQ      'C'                                          Closed
     C                   MOVE      'Y'           WKRETL                         Retail a/c n/f
     C                   MOVE      'Y'           WKNOST                         Nostro a/c n/f
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C/COPY OFCPYSRCZ,CGL135_102                                                             CGL135B
      *
      *     Retail transaction
      *
      * The Memo file is not updated if the account is not found or
      *   the account is closed.  This is applicable for only
      *   interface batch with 'In' currency and Retail/Nostro account.
      *   The switchable feature CEU013 must have been installed.
     C     WKRETL        IFNE      'Y'
     C                   EXSR      RETSR
     C                   END
      *
      *     Prono transaction
      *
      * If Retail account was not found, bypass the Nostro processing
      *
     C     BTNNBI        IFNE      *BLANKS
     C     WKRETL        ANDNE     'Y'
     C                   EXSR      PROSR
     C                   END
      *
      **  On Line Position Update (only if account code is
      **  Spot Trade Account Code)
      *
      * If Retail account or Nostro account was not found, on line
      *   position update is not performed.
      *
     C     BTACCD        IFEQ      BLSPTA
     C     WKRETL        ANDNE     'Y'
     C     WKNOST        ANDNE     'Y'
     C                   EXSR      OLPSR
     C                   END
      *
      *   FOR ALL TYPES OF ACCOUNTS
     C     UPDIND        IFNE      'Y'
     C                   MOVE      'Y'           UPDIND
     C                   END
      *
     C/COPY OFCPYSRCZ,CGL135_111                                                            MD023889
      *
      *     Shadow postings and batch transaction record update
      *
      *
      * If Retail account or Nostro account was not found, G/L
      *   account meovements are not generated and the Shadow
      *   postings flag is not updated to 'Y'.
      *
     C     UPDIND        IFEQ      'Y'
     C                   MOVE      'N'           UPDIND
     C     WKRETL        IFNE      'Y'
     C     WKNOST        ANDNE     'Y'
     C                   EXSR      RSACSR
     C                   ENDIF
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *     RETSR  SR     SUB-ROUTINE                                    *
      *                                                                  *
      *     Memos processing - (Retail)                                  *
      *                                                                  *
      ********************************************************************
      *
     C     RETSR         BEGSR
      *
      ** Move alpha fields to numeric for call.
     C                   MOVE      BTCUST        W0CNUM
     C                   MOVE      BTACCD        W0ACCD
     C                   MOVE      BTACSN        W0ACSQ
      *
      * If switchable function CEU013 is installed, the batch is an
      *   interface batch, the item currency is an 'In' currency,
      *   the account may not be opened yet.  The call to AOMEMSU0
      *   issues a data base error if the record is not found.
      *   Hence the account is first verified before giving the
      *   call for update.
      *
     C                   MOVE      *BLANKS       W0RTCD
     C     CEU013        IFEQ      'Y'
     C     WKINCY        ANDEQ     'Y'
      ** Call Access Object AOMEMSR0
     C                   CALL      'AOMEMSR0'
     C                   PARM      *BLANKS       W0RTCD            7            I:Return code
     C                   PARM      '*VERIFY'     W0OPTN            7            I:Option
     C                   PARM      0             W0RETL           10 0          O:Retail A/C No
     C**********         PARM                    W0CNUM            6 0         O:Customer No. CSD027
     C                   PARM                    W0CNUM            6            O:Customer No CSD027
     C                   PARM      BTCYCD        W0CUCD            3            O:Currency
     C**********         PARM                    W0ACCD            4 0          O:Account Cod CGL029
     C                   PARM                    W0ACCD                                       CGL029
     C                   PARM                    W0ACSQ            2 0          O:Account Seq.
     C                   PARM      BTIBCA        W0BRCA            3            O:Branch
     C     DSMEMS        PARM      DSMEMS        DSFDY                                        222373
     C     W0RTCD        IFEQ      '*NRF   '
     C                   MOVE      'Y'           WKRETL
     C                   ENDIF
     C     W0RTCD        IFNE      *BLANKS
     C     W0RTCD        ANDNE     '*NRF   '
     C                   MOVE      *BLANKS       W0RTCD
     C                   ENDIF
     C                   ENDIF
      *
     C     W0RTCD        IFEQ      *BLANKS
      *
      ** If a credit transaction reverse the sign.
     C     BTDCIN        IFEQ      'C'
     C                   Z-SUB     BTPTAM        W0AMT
     C                   ELSE
     C                   Z-ADD     BTPTAM        W0AMT
     C                   ENDIF
     C/COPY OFCPYSRCZ,CGL135_103                                                             CGL135B
      *
      ** Call Access Object AOMEMSU0
     C                   CALL      'AOMEMSU0'
     C                   PARM      *BLANKS       W0RTCD            7            I:Return code
     C                   PARM      0             W0RETL           10 0          O:Retail A/C No
     C**********         PARM                    W0CNUM            6 0         O:Customer No. CSD027
     C                   PARM                    W0CNUM            6            O:Customer No CSD027
     C                   PARM      BTCYCD        W0CUCD            3            O:Currency
     C**********         PARM                    W0ACCD            4 0          O:Account Cod CGL029
     C                   PARM                    W0ACCD                                       CGL029
     C                   PARM                    W0ACSQ            2 0          O:Account Seq.
     C                   PARM      BTIBCA        W0BRCA            3            O:Branch
     C/COPY OFCPYSRCZ,CGL135_104                                                             CGL135B
     C                   PARM      BTPTDT        W0PSTD            5 0          O:Posting date
     C/COPY OFCPYSRCZ,CGL135_105                                                             CGL135B
     C                   PARM      BTVLDT        W0VDAT            5 0          O:Value date
     C                   PARM                    W0AMT            15 0          O:Movement amt
     C                   PARM      'N'           W0FTOV            1            O:FT override
      *
     C     W0RTCD        IFNE      '       '
     C                   Z-ADD     03            DBASE                          * DB ERROR 03 *
     C                   MOVE      'MEMOS'       DBFILE
     C                   EXSR      ERRSR
     C                   ELSE
     C                   MOVE      'Y'           UPDIND            1
     C                   END
     C                   ENDIF
      *
      ** Red INDEX. This workfield was originally defined in
      ** SR/ACCMSR but this subroutine has been replaced by the
      ** AOMEMSU0 access object processing.
     C                   Z-ADD     *ZERO         INDEX             1 0
      *
     C                   ENDSR
      ********************************************************************
      /EJECT                                                             *
      ********************************************************************
      *                                                                  *
      *     PROSR  SR     SUB-ROUTINE                                    *
      *                                                                  *
      *     Prono processing - (Nostro)                                  *
      *                                                                  *
      ********************************************************************
      *
     C     PROSR         BEGSR
      *
      *     Access Prono record
      *
     C                   EXSR      ACCPSR
      *
     C                   Z-ADD     1             X                 1 0
      **
      **   Set up next working day in loan CCY
      **
     C                   MOVE      BTCYCD        ZCCY
     C     PRD(5)        ADD       1             ZDAYNO
     C                   Z-ADD     0             ZNRDYS
      **
      *    Access nostro details
      **
     C                   CALL      'AONOSTR0'    PLIST1
      *
     C     P@RTCD        IFNE      *BLANK                                         * DBERR 14 *
      * Ignore the error if CEU013 is installed, the batch is from
      *  an external interface and the currency is an 'In' currency.
      *
     C     CEU013        IFNE      'Y'
     C     WKINCY        ANDNE     'Y'
     C                   MOVE      'SDNOSTPD'    DBFILE
     C                   MOVE      'NOSKEY'      DBKEY
     C                   Z-ADD     14            DBASE
     C                   MOVEL     P@RTCD        W0RTCD
     C                   EXSR      ERRSR
     C                   ELSE
     C                   MOVE      'Y'           WKNOST
     C                   ENDIF
     C                   ELSE
     C                   MOVE      A7NOSN        ZLOC              3
     C                   END
      *
      * If CEU013 switchable function is installed, Nostro account is
      *   not found, the batch is from external interface and the
      *   currency is an 'In' currency, then the remaining checks are
      *   not carried out.
      *
     C     P@RTCD        IFEQ      *BLANK
      *
      *   Output database error message if error occurs - ignore condition
      *   where nostro record not found on PRONO, as nostro may have
      *   been set up today.
     C     PRNERR        IFEQ      'Y'
     C     A7LCD         IFNE      RDATE
     C     A7TYLC        ORNE      'I'
     C                   Z-ADD     06            DBASE                          * DB ERROR 06 *
     C                   MOVE      'PRONO'       DBFILE
     C                   MOVEL     PROERR        DBKEY
     C                   MOVEL     'PRONO'       W0RTCD
     C                   EXSR      ERRSR
     C                   END
     C                   END
      *
     C                   Z-ADD     ZNRDYS        #ZNRDYS           2 0                        CAP084
     C                   Z-ADD     0             ZDYNBR                                       CAP084
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO
     C**********         PARM                    ZNRDYS                                       CAP084
     C                   PARM                    #ZNRDYS                                      CAP084
     C                   PARM                    ZDYNBR
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
      *
     C                   Z-ADD     ZDYNBR        PNDS              5 0
      **
     C     BTVLDT        IFLT      PNDS
      *
      *
      ** Access the date 'equal to' or 'greater than' the value date
      *
     C     BTVLDT        LOOKUP    PRD(X)                             09  09
      *
      *     Array pointer would be positioned at:
      *
      *     Equal element     - When an *EQ is on
      *     Greater than element - When *EQ is off and *HI is on
      *     First element     - When both *EQ & *HI are off
      *
     C     X             DOWLT     6
      *
     C     BTDCIN        IFEQ      'D'
     C                   ADD       BTPTAM        PRB(X)
     C                   END
      *
     C     BTDCIN        IFEQ      'C'
     C                   SUB       BTPTAM        PRB(X)
     C                   END
      *
     C                   ADD       1             X
     C                   END
      *
     C                   MOVE      'Y'           UPDIND
     C                   MOVE      'Y'           NOSIND            1
     C                   END
     C                   ENDIF
      *
      *     Prono record update
      *
     C  N07              UPDATE    PRONOPNF                             08
      *
      *     Data base error if update fails
      *
     C     *IN08         IFEQ      '1'
     C                   Z-ADD     05            DBASE                          * DB ERROR 05 *
     C                   MOVE      'PRONO'       DBFILE
     C                   MOVEL     PROERR        DBKEY
     C                   MOVEL     'PRONO'       W0RTCD
     C                   EXSR      ERRSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *     ACCPSR SR     SUB-ROUTINE                                    *
      *                                                                  *
      *     Access Prono record                                          *
      *                                                                  *
      ********************************************************************
      *
     C     ACCPSR        BEGSR
      *
     C                   Z-ADD     *ZERO         INDEX
     C                   MOVE      BTCYCD        KCCY
     C                   MOVE      BTNNBI        KNNO
      *
      *     Try and retry to access record (five attempts)
      *
     C     INDEX         DOWLT     5
      *
     C     PROKEY        CHAIN     PRONOPNF                           0708
      *
     C     *IN07         IFEQ      '1'
     C                   Z-ADD     5             INDEX
     C                   ELSE
     C     *IN08         IFEQ      '0'
     C                   Z-ADD     5             INDEX
     C                   ELSE
     C                   ADD       1             INDEX
     C                   END
     C                   END
      *
     C                   END
      *
      *     Data base error if Prono record found -  but locked
      *
     C     *IN08         CABEQ     '1'           PDBERR
      *
      *     If Prono record not found -  try for an unallocated nostro
      *
     C     *IN07         IFEQ      '1'
     C     RECI          ORNE      'D'
      *
     C                   Z-ADD     *ZERO         INDEX
     C                   Z-ADD     *ZEROS        KNNO
      *
      *     Try and retry to access record (five attempts)
      *     Set on *IN07 if record not found, or *IN08 if an error occurs 092161
      *
     C     INDEX         DOWLT     5
      *
     C     PROKEY        CHAIN     PRONOPNF                           0708
      *
      *     If record not on file, exit loop
     C     *IN07         IFEQ      '1'
     C                   Z-ADD     5             INDEX
     C                   ELSE
      *
      *     If correct record found, exit loop
     C     *IN08         IFEQ      '0'
     C                   Z-ADD     5             INDEX
      *
      *     else retry
     C                   ELSE
     C                   ADD       1             INDEX
     C                   END
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C     PDBERR        TAG
      *
      *
      *
      *     Set up Nostro Error flag if error occurred
      *     If record not on file (i.e. nostro has been set up today)
      *     do NOT set up error flag.
     C                   MOVE      ' '           PRNERR
     C     *IN08         IFEQ      '1'
     C                   MOVE      'Y'           PRNERR            1
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *     OLPSR  SR     SUB-ROUTINE                                 *
      *                                                               *
      *     On Line Position Processing (only for Spot Trade Account) *
      *                                                               *
      *****************************************************************
      *
     C     OLPSR         BEGSR
      *
      **  Set up parameters for access object
      *
     C                   MOVEL     *BLANKS       WRK8              8
     C                   MOVEL     *BLANKS       WRK6              6
     C                   MOVEL     BTIBCA        WRK6
     C                   MOVE      BTCYCD        WRK6
     C                   MOVEL     WRK6          WRK8
     C                   MOVE      '01'          WRK8
      *
     C                   MOVEL     *BLANKS       WRK1              1
     C     BTDCIN        IFEQ      'C'
     C                   MOVEL     'I'           WRK1
     C                   ELSE
     C                   MOVEL     'O'           WRK1
     C                   ENDIF
      *
      **  Update On Line Position
      *
     C                   CALL      'AOOLPSU0'                           9090
     C                   PARM      *BLANKS       O#RTN             7            B: Return code
     C                   PARM      WRK8          O#KOLP            8            I: Olpos key
     C                   PARM      BTVLDT        O#VDAT            5 0          I: Value date
     C                   PARM      BTPTAM        O#AMT            15 0          I: Post amount
     C                   PARM      WRK1          O#IO              1            I: In/Out
      *
     C     *IN90         IFEQ      '1'
     C     O#RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    DBFILE                         ***************
     C                   MOVEL     'AOOLPSU0'    DBKEY                          * DB ERROR 16 *
     C                   Z-ADD     16            DBASE                          ***************
     C                   MOVEL     O#RTN         W0RTCD
     C                   EXSR      ERRSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *     RSACSR SR     SUB-ROUTINE                                    *
      *                                                                  *
      *     Shadow postings to RSACMTPD                                  *
      *                                                                  *
      ********************************************************************
      *
     C     RSACSR        BEGSR
      *
      *     For unallocated nostros initialise account key
      *
     C     NOSIND        IFEQ      'Y'
     C     NOSN          ANDEQ     *ZEROS
      *
     C**********         Z-ADD     *ZEROS        CUSN                                         CSD027
     C                   EVAL      CUSN = *BLANKS                                             CSD027
     C                   Z-ADD     *ZEROS        ACDE
     C                   Z-ADD     *ZEROS        ASNC
     C                   MOVE      *BLANKS       BRCA
     C                   ELSE
     C                   MOVE      BTCUST        CUSN
     C                   MOVE      BTACCD        ACDE
     C                   MOVE      BTACSN        ASNC
     C                   MOVE      BTIBCA        BRCA
      *
     C                   END
      *
     C                   MOVE      BTCYCD        CCYD
     C                   Z-ADD     RDATE         PTDT
     C/COPY OFCPYSRCZ,CGL135_106                                                             CGL135B
     C                   Z-ADD     BTVLDT        VUDT
     C                   MOVE      'ME'          TRYP
     C                   MOVE      BTNVCD        NRTC
     C                   MOVE      BTNRDC        NRTD
     C/COPY WNCPYSRC,GLH00474
     C                   Z-ADD     *ZEROS        WTRN              6 0
     C                   MOVEL     BTBTNB        WTRN              6 0
     C                   ADD       BTBINB        WTRN
     C                   MOVE      WTRN          TNMR
     C/COPY WNCPYSRC,GLH00475
      *
      * Set up Trans. number with Batch number in first 3
      * digits, and Batch item number in last 3 digits
     C                   MOVEL     BTBTNB        WBNUM
     C                   Z-ADD     BTBINB        #BINB             3 0
     C                   MOVE      #BINB         WBINB
     C                   MOVEL     WTRNM         TNMR
     C                   MOVE      BTCQNB        CQNR
     C                   Z-ADD     BTPTAM        MVAM
      *
     C     BTDCIN        IFEQ      'D'
     C                   Z-ADD     *ZERO         DORC
     C                   END
      *
     C     BTDCIN        IFEQ      'C'
     C                   Z-ADD     1             DORC
     C                   END
      *
     C                   IF        CAP205 = 'Y'                                               CAP205
     C                   EVAL      CMOD = 'GL'                                                CAP205
     C                   EVAL      MTYP = 'S'                                                 CAP205
     C                   ELSE                                                                 CAP205
     C                   EVAL      CMOD = *BLANKS                                             CAP205
     C                   EVAL      MTYP = *BLANKS                                             CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C                   WRITE     RSACMTPO                             10
      *
      *     Data base error if write fails
      *
     C     *IN10         IFEQ      '1'
     C                   Z-ADD     07            DBASE                          * DB ERROR 07 *
     C                   MOVE      'RSACM'       DBFILE
     C                   MOVEL     'ON WRITE'    DBKEY
     C                   MOVEL     'RSACM'       W0RTCD
     C                   EXSR      ERRSR
     C                   ELSE
     C
      *
      * Data export for CCRM - Limits
      *
     C     CDE001        IFEQ      'Y'
     C     NOSIND        IFNE      'Y'
     C     NOSN          ORNE      *ZEROS
     C                   MOVEL     BRCA          RSBRCA
     C                   MOVEL     CUSN          WKFLD9                                       CGL029
     C                   MOVE      CCYD          WKFLD9                                       CGL029
     C                   MOVEL     ACDE          WKFLD12                                      CGL029
     C                   MOVE      ASNC          WKFLD12                                      CGL029
     C     WKFLD9        CAT       WKFLD12:0     W#ACID                                       CGL029
     C                   MOVE      BRCA          W#ACID                                       CGL029
     C                   MOVEL     W#ACID        T#TREF
      *                                                                                       CDE005
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   MOVE      BTNRDC        T#RSRV                                       CDE005
     C                   ENDIF                                                                CDE005
      *                                                                                       CDE005
     C                   CALL      'DEWTTRIG'
     C**********         PARM                    T#TREF           20                          CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'ACCT'        T#TCAT            4
     C                   PARM                    T#RSRV           10                          CDE005
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      'N'           NOSIND
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *     INZSR  SR     SUB-ROUTINE                                    *
      *                                                                  *
      *     Program initialisation                                       *
      *                                                                  *
      ********************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     PLIST1        PLIST
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      *BLANK        P@CUST            6
      *
     C                   PARM      BTCYCD        P@CYCD            3
     C**********         PARM      *BLANK        P@ACCD            4                          CGL029
     C                   PARM      *BLANK        P@ACCD                                       CGL029
     C                   PARM      *BLANK        P@ACSN            2
      *
     C                   PARM      BTNNBI        P@NONB            2
     C                   PARM      *BLANK        P@BRCD            3
     C                   PARM      *BLANK        P@CSSN           10
     C                   PARM      *BLANK        P@PNOI            1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *     Accept batch number
      *
     C     *ENTRY        PLIST
     C                   PARM      *BLANKS       RTCD              7
     C                   PARM                    D@JENP
      *
      *     Move alpha parameter to numeric key field
      *
     C                   MOVEL     BTBTNB        BATCH             6
     C                   MOVE      BTBINB        BATCH
      *
      *     Setup program name for reporting DB errors
      *
     C                   MOVE      'GL004446'    DBPGM
      *
      *     Accept run date
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   Z-ADD     EJNB          RDATE             5 0
      *
      *     Set up Prono key
      *
     C     PROKEY        KLIST
     C                   KFLD                    KCCY              3
     C                   KFLD                    KNNO              2 0
      *
      **  Access SAR details file to see if CEU013 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU013'      WSARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU013            1
     C                   ELSE
     C                   MOVE      'N'           CEU013
     C                   ENDIF
     C                   MOVE      *BLANKS       WKINCY            1
     C                   MOVE      *BLANKS       WKCYCD            3
      *
      ** Determine if Data Export for CCRM Limits is active
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      WSARD
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CDE001            1
     C                   ENDIF
      *                                                                                       CDE005
      ** Determine if Data Export - Reservation ID is active                                  CDE005
      *                                                                                       CDE005
     C                   CALL      'AOSARDR0'                                                 CDE005
     C                   PARM      *BLANKS       @RTCD                                        CDE005
     C                   PARM      '*VERIFY'     @OPTN                                        CDE005
     C                   PARM      'CDE005'      WSARD                                        CDE005
      *                                                                                       CDE005
     C     @RTCD         IFEQ      *BLANK                                                     CDE005
     C                   MOVE      'Y'           CDE005            1                          CDE005
     C                   ENDIF                                                                CDE005
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      WSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 18                                                 CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      ERRSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
     C/COPY WNCPYSRC,GLH00476
      *
     C     KBTCH         KLIST
     C                   KFLD                    W0TBN             3
     C                   KFLD                    W0INB             3 0
                                                                                              CAP205
      ** Access SAR details file to determine if CAP205 is ON.                                CAP205
                                                                                              CAP205
     C                   EVAL      CAP205 = 'N'                                               CAP205
     C                   CALL      'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       @RTCD                                        CAP205
     C                   PARM      '*VERIFY'     @OPTN                                        CAP205
     C                   PARM      'CAP205'      WSARD                                        CAP205
      *                                                                                       CAP205
     C                   IF        @RTCD = *BLANKS                                            CAP205
     C                   EVAL      CAP205 = 'Y'                                               CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C/COPY OFCPYSRCZ,CGL135_107                                                             CGL135B
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *     ERRSR  SR     SUB-ROUTINE                                    *
      *                                                                  *
      *     Error routine                                                *
      *                                                                  *
      ********************************************************************
      *
     C     ERRSR         BEGSR
      *
     C                   MOVE      W0RTCD        RTCD
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ENDIF                                                                CSC022
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2002
