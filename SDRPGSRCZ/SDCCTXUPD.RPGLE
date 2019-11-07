     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details by Country of Tax Update')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCCTXUPD - SD Customer Details by Country of Tax Update     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CER069             Date 03Jul14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR740756           Date 03Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26917A          Date 27Jan10               *
      *                 BUG26917           Date 20Jan10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22578A          Date 17Feb09               *
      *                 BUG22794           Date 10Feb09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 236137             Date 21Sep05               *
      *  Prev Amend No. 234227             Date 27Jun05               *
      *                 232543             Date 31Mar05               *
      *                 CGL032  *Create    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER069 - German Tax Enhancement                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR740756 - Exemption Threshold details is incorrect in       *
      *             Exemption Threshold Enquiry Screen                *
      *             (Child: AR740757)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG26917A - Reverse fix for bug26917                         *
      *  BUG26917 - COB error when customer is declared as taxable    *
      *           w/ German features installed and no additional      *
      *           customers information is set up                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22578A - Amend screen flow for German Taxes               *
      *  BUG22794 - Limit Utilisation Enquiry displaying incorrect    *
      *             data                                              *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER048 - German Features - Taxes                             *
      *  236137 - Change Control for CGL031 (Recompile)               *
      *  234227 - Add function to delete record/s.                    *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SD Customer Details by Country of Tax - Update
     FSDACTXL0  UF A E           K DISK    COMMIT
      **********                                                                    CER048 BUG22578A
      ***Midas*SD*Interest**Payment*History*File                                    CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     F***SDINPHL0  UF A E           K DISK    COMMIT                                CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
      ***Midas*SD*Exemption*Threshold*History*File                                  CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     F***SDTHRHL0  UF A E           K DISK    COMMIT                                CER048 BUG22578A
      **Customer*Details*File*-*by*Customer*number*                               BUG26917 BUG26917A
     F***SDCUSTL1  IF   E           K DISK    PREFIX(C_)                          BUG26917 BUG26917A
                                                                                              CER059
      ** Midas SD Interest  Payment History File                                              CER059
     FSDINPHL0  UF A E           K DISK    COMMIT                                             CER059
                                                                                              CER059
      ** Midas SD Exemption Threshold History File                                            CER059
     F***SDTHRHL0  UF A E           K DISK    COMMIT                                 CER059 AR740756
     FSDTHRHL3  UF A E           K DISK    COMMIT                                           AR740756
                                                                                            AR740756
      ** Midas SD Joint Account Member File                                                 AR740756
                                                                                            AR740756
     FSDJACCL4  IF   E           K DISK                                                     AR740756

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Standard D-specs
      ** ================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

      /COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      /COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.

      /COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.

      /COPY ZACPYSRC,ERR_XARRYS

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

      ** New Details in File Format
     D NwDlFilFmt    E DS                  EXTNAME(SDVCCTXPD)

      ** Custumer Details by Country of Tax File Format
     D SDDlFilUpd    E DS                  EXTNAME(SDACTXPD)

      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CER048
      ** Third DS for access programs, long data structure                                    CER048
      *                                                                                       CER048
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CER048

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** Midas API Message Header Format Definition
     D APHEAD        E DS                  EXTNAME(APHEADPD)

      ** Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                                       CER048
      ** External DS for Bank Details                                                         CER048
      *                                                                                       CER048
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CER048
      *                                                                                       CER048
      ** External DS for Customer Details                                                     CER048
      *                                                                                       CER048
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER048
      *                                                                                       CER048
      ** External DS for Additional Customer Details                                          CER048
      *                                                                                       CER048
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                                  CER048
      *                                                                                       CER048
      ** External DS for Branch Details                                                       CER048
      *                                                                                       CER048
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CER048
     D                                     PREFIX(@)                                          CER048
      *                                                                                       CER048
      ** External DS for Location  Details                                                    CER048
      *                                                                                       CER048
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  CER048
      *                                                                                       CER048
      ** External DS for Country of Tax Code Details                                          CER048
      *                                                                                       CER048
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  CER048

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      **Timestamp
     D PTimeStamp      S             26Z
                                                                                              234227
      ** Entry Parameters                                                                     234227
     D PAction         S              1A                                                      234227
     D PCustNo         S              6A                                                      234227

      ** Fields defined for Calling SDCCTXLOG

     D CSC011          S              1A
     D TRANSDTL        S           5800A
     D PCustNum        S             18A
     D PACustNo        S             18A
     D P@Timestamp     S             26A
     D PSard           S              6A

      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
     D PRetCode        S              7A
     D PMode           S              7A                                                      CER059
     D PKyst           S              7A                                                      CER048
     D PCustNo10       S             10A                                                      CER048
     D PBrca           S              3A                                                      CER048
     D PLccd           S              3A                                                      CER048
      *                                                                                       CER048
     D WCloc           S              2A                                                      CER048
     D WCncd           S              2A                                                      CER048
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
     D CER069          S              1A                                                      CER069

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
     C     KEY1          KLIST
     C                   KFLD                    CTCUST
     C                   KFLD                    CTCTTX

      ** If Joint Account Type changed from 'Y' to 'N', delete all                            234227
      ** records in SDACTXPD for this customer.                                               234227
                                                                                              234227
     C                   IF        PAction = 'D'                                              234227
     C*****PCustNo       CHAIN     SDCUSTL1                                       BUG26917 BUG26917A
     C**********         IF        C_BBTAIN <> 'Y'                                BUG26917 BUG26917A
     C**********                   AND CER048 = 'Y'                               BUG26917 BUG26917A
     C     PCustNo       SETLL     SDACTXL0                                                   234227
     C     *IN10         DOWEQ     '0'                                                        234227
     C     PCustNo       READE     SDACTXL0                               10                  234227
     C                   IF        *IN10 = '0'                                                234227
     C                   DELETE    SDACTXL0                                                   234227
     C                   ENDIF                                                                234227
     C                   ENDDO                                                                234227
     C**********         ELSEIF    CER048 = 'N'                                   BUG26917 BUG26917A
     C*****PCustNo       SETLL     SDACTXL0                                       BUG26917 BUG26917A
     C******IN10         DOWEQ     '0'                                            BUG26917 BUG26917A
     C*****PCustNo       READE     SDACTXL0                               10      BUG26917 BUG26917A
     C**********         IF        *IN10 = '0'                                    BUG26917 BUG26917A
     C**********         DELETE    SDACTXL0                                       BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
     C**********         ENDDO                                                    BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
     C                   ELSE                                                                 234227
                                                                                              234227
     C     KEY1          CHAIN     SDACTXL0                           10

      ** Generate Timestamp

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp

      ** Translate records to file layout

     C                   IF        NwDlFilFmt <> SDDlFilUpd                                   CER048
      *                                                                                       CER048
     C                   EVAL      CTTMST = PTimestamp

     C                   MOVEL     NwDlFilFmt    SDDlFilUpd

     C                   IF        *IN10 = *OFF
     C                   UPDATE    SDACTXD0                             20

     C                   IF        *IN20 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDACTXPD'
     C                   EVAL      DBKEY = CTCUST + CTCTTX
     C                   Z-ADD     001           DBase
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF

     C                   ELSE
     C                   WRITE     SDACTXD0
     C                   ENDIF
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C**********         IF        CER048 = 'Y'                                     CER048 BUG22578A
     C**********         EXSR      SRWrInph                                         CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
     C                   IF        CER048 = 'Y'                                               CER059
     C                             AND PMode = '*CUSDVU'                                      CER059
     C                   EXSR      SRWrInph                                                   CER059
     C                   ENDIF                                                                CER059
      *                                                                                       CER048
     C                   ENDIF                                                                234227

      ** If 24x7 Midas Availability is installed
      ** and Support System is active

     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)

     C                   CALLB     'SDCCTXLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    SDDlFilUpd
     C                   PARM                    TRANSDTL

      ** If there is no error, write the log file

     C                   IF        RetCodeOut = *BLANKS

     C                   EVAL      APTGTTYPE = 'SDACUD'
     C                   EVAL      APFOTRANID = AXFRNT
     C                   EVAL      APRPRLOCN  = AXREPA
     C                   EVAL      APUSERID   = PSUser
     C                   EVAL      APMIDUSR   = PSUser

     C                   MOVEL     AXCUST        PCustNum

     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       P@Timestamp
     C                   PARM                    PCustNum
     C                   PARM      *BLANKS       PACustNo

     C                   ENDIF

      ** If there is an error in either log file, end program

     C                   IF        RetCodeOut <> *BLANKS
     C                   EVAL      PRetCode = '*ERROR'
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      *INLR = *ON                                                232543
                                                                                              232543
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************             CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
      **SRWrInph*-*Subroutine*to*write*details*in*SDINPHPD*file********             CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
      **Called*By*-*Main*Processing************************************             CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
      **Calls*-*SRErr**************************************************             CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
     C*****SRWrInph      BEGSR                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
      ***Get*corresponding*record*from*additional*customer*file                     CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         CALL      'AOACUSR0'                                       CER048 BUG22578A
     C**********         PARM      *BLANKS       PRtcd                              CER048 BUG22578A
     C**********         PARM      '*KEY   '     POptn                              CER048 BUG22578A
     C**********         PARM                    PCustNo                            CER048 BUG22578A
     C*****SDACUS        PARM      SDACUS        DSLDY                              CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        PRtcd <> *BLANKS                                 CER048 BUG22578A
     C**********         EVAL      DBFile =  'SDACUSPD'                             CER048 BUG22578A
     C**********         EVAL      DBase = 005                                      CER048 BUG22578A
     C**********         EVAL      DBKey = PCustNo                                  CER048 BUG22578A
     C**********         EXSR      SRErr                                            CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        CTETXS = 'S' OR CTETXS = 'D'                      CER048 BUG22794
     C**********                   OR CTETXS = 'T'                                   CER048 BUG22794
      **********                                                                    CER048 BUG22578A
      ***Access*Branch*Code*for*Customer                                            CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         CALL      'AOCUSTR0'                                       CER048 BUG22578A
     C**********         PARM      *BLANKS       PRtcd                              CER048 BUG22578A
     C**********         PARM      '*KEY'        POptn                              CER048 BUG22578A
     C**********         PARM      PCustNo       PCustNo10                          CER048 BUG22578A
     C**********         PARM                    PKyst                              CER048 BUG22578A
     C*****SDCUST        PARM      SDCUST        DSSDY                              CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        PRtcd <> *BLANKS                                 CER048 BUG22578A
     C**********         EVAL      DBFile =  'SDCUSTPD'                             CER048 BUG22578A
     C**********         EVAL      DBase = 004                                      CER048 BUG22578A
     C**********         EVAL      DBKey = POptn                                    CER048 BUG22578A
     C**********         EXSR      SRErr                                            CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         EXSR      SRCttxDet                                        CER048 BUG22578A
      **********                                                                  BUG22794 BUG22578A
     C**********         IF        CTCTTX = EWCTRR                                BUG22794 BUG22578A
      **********                                                                  BUG22794 BUG22578A
     C**********         IF        CTETXS = 'S' OR CTETXS = 'D'                   BUG22794 BUG22578A
     C**********                   OR CTETXS = 'T'                                BUG22794 BUG22578A
      **********                                                                    CER048 BUG22578A
      ***Check*record*exist*in*Interest*Payment*History*File                        CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C*****PCustNo       CHAIN     SDINPHL0                                         CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        NOT %FOUND(SDINPHL0)                             CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         EVAL      TIBRCA =  BBBRCD                                 CER048 BUG22578A
     C**********         EVAL      TICUST =  PCustNo                                CER048 BUG22578A
     C**********         EVAL      TILSSD =  *ZEROS                                 CER048 BUG22578A
     C**********         EVAL      TIPGNO =  *ZEROS                                 CER048 BUG22578A
     C**********         EVAL      TISTRQ =  *BLANKS                                CER048 BUG22578A
     C**********         EVAL      TIUTTH =  *ZEROS                                 CER048 BUG22578A
     C**********         EVAL      TITOUT =  *ZEROS                                 CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        E5JATP = 'Y'                                     CER048 BUG22578A
     C**********         EVAL      TICUTH = EWJTTH                                  CER048 BUG22578A
     C**********         ELSE                                                       CER048 BUG22578A
     C**********         EVAL      TICUTH = EWINTH                                  CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         WRITE     SDINPHD0                                         CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C*****PCustNo       CHAIN     SDTHRHL0                                         CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        NOT %FOUND(SDTHRHL0)                             CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        TICUTH <> *ZEROS                                 CER048 BUG22578A
     C**********         EVAL      TECUST = TICUST                                  CER048 BUG22578A
     C**********         EVAL      TEACTD = BJRDNB                                  CER048 BUG22578A
     C**********         EVAL      TECEXT = TICUTH                                  CER048 BUG22578A
     C**********         EVAL      TETRAD = E5EADT                                  CER048 BUG22578A
     C**********         EVAL      TETRVD = E5EVDT                                  CER048 BUG22578A
     C**********         EVAL      TETRMD = E5ETXT                                  CER048 BUG22578A
     C**********         WRITE     SDTHRHD0                                         CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ELSE                                                       CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        TICUTH <> *ZEROS AND                             CER048 BUG22578A
     C**********                   TEACTD = BJRDNB                                  CER048 BUG22578A
     C**********         EVAL      TEACTD = BJRDNB                                  CER048 BUG22578A
     C**********         EVAL      TECEXT = TICUTH                                  CER048 BUG22578A
     C**********         EVAL      TETRAD = E5EADT                                  CER048 BUG22578A
     C**********         EVAL      TETRVD = E5EVDT                                  CER048 BUG22578A
     C**********         EVAL      TETRMD = E5ETXT                                  CER048 BUG22578A
     C**********         UPDATE    SDTHRHD0                                         CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ELSEIF    TICUTH <> *ZEROS AND                             CER048 BUG22578A
     C**********                   TEACTD <> BJRDNB                                 CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         EVAL      TECUST = TICUST                                  CER048 BUG22578A
     C**********         EVAL      TEACTD = BJRDNB                                  CER048 BUG22578A
     C**********         EVAL      TECEXT = TICUTH                                  CER048 BUG22578A
     C**********         EVAL      TETRAD = E5EADT                                  CER048 BUG22578A
     C**********         EVAL      TETRVD = E5EVDT                                  CER048 BUG22578A
     C**********         EVAL      TETRMD = E5ETXT                                  CER048 BUG22578A
     C**********         WRITE     SDTHRHD0                                         CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ELSE                                                       CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C*****PCustNo       CHAIN     SDINPHL0                                         CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        %FOUND(SDINPHL0)                                 CER048 BUG22578A
     C**********         EVAL      TICUTH = *ZEROS                                  CER048 BUG22578A
     C**********         UPDATE    SDINPHD0                                         CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C*****PCustNo       CHAIN     SDTHRHL0                                         CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        NOT %FOUND(SDTHRHL0)                             CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         EVAL      TECUST = TICUST                                  CER048 BUG22578A
     C**********         EVAL      TEACTD = BJRDNB                                  CER048 BUG22578A
     C**********         EVAL      TECEXT = TICUTH                                  CER048 BUG22578A
     C**********         EVAL      TETRAD = E5EADT                                  CER048 BUG22578A
     C**********         EVAL      TETRVD = E5EVDT                                  CER048 BUG22578A
     C**********         EVAL      TETRMD = E5ETXT                                  CER048 BUG22578A
     C**********         WRITE     SDTHRHD0                                         CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ELSE                                                       CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        TEACTD = BJRDNB                                  CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         EVAL      TEACTD = BJRDNB                                  CER048 BUG22578A
     C**********         EVAL      TECEXT = TICUTH                                  CER048 BUG22578A
     C**********         EVAL      TETRAD = E5EADT                                  CER048 BUG22578A
     C**********         EVAL      TETRVD = E5EVDT                                  CER048 BUG22578A
     C**********         EVAL      TETRMD = E5ETXT                                  CER048 BUG22578A
     C**********         UPDATE    SDTHRHD0                                         CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ELSE                                                       CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         EVAL      TECUST = TICUST                                  CER048 BUG22578A
     C**********         EVAL      TEACTD = BJRDNB                                  CER048 BUG22578A
     C**********         EVAL      TECEXT = TICUTH                                  CER048 BUG22578A
     C**********         EVAL      TETRAD = E5EADT                                  CER048 BUG22578A
     C**********         EVAL      TETRVD = E5EVDT                                  CER048 BUG22578A
     C**********         EVAL      TETRMD = E5ETXT                                  CER048 BUG22578A
     C**********         WRITE     SDTHRHD0                                         CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                  BUG22794 BUG22578A
     C**********         ENDIF                                                    BUG22794 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ENDSR                                                      CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
      ***/EJECT*                                                                    CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
      ***SRCttxDet:*Retrieve*Country*of*Tax*Details********************             CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
      ***Called*By:*SRInitInTx*****************************************             CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
      ***Calls:*None***************************************************             CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
     C*****SRCttxDet     BEGSR                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         CALL      'AOBRCHR0'                                       CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         PARM      *BLANKS       PRtcd                              CER048 BUG22578A
     C**********         PARM      '*KEY'        POptn                              CER048 BUG22578A
     C**********         PARM      BBBRCD        PBrca                              CER048 BUG22578A
     C*****SDBRCH        PARM      SDBRCH        DSSDY                              CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        (PRtcd <> *BLANKS)                               CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C******LOCK         IN        LDA                                              CER048 BUG22578A
     C**********         EVAL      DBFILE = 'SDBRCHPD'                              CER048 BUG22578A
     C**********         EVAL      DBKEY = BBBRCD                                   CER048 BUG22578A
     C**********         EVAL      DBase = 006                                      CER048 BUG22578A
     C**********         OUT       LDA                                              CER048 BUG22578A
     C**********         EXSR      SRERR                                            CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
      ***Get*the*Location*Code*to*get*the*country*details                           CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         CALL      'AOLOCNR0'                                       CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         PARM      *BLANKS       PRtcd                              CER048 BUG22578A
     C**********         PARM      '*KEY'        POptn                              CER048 BUG22578A
     C**********         PARM      @A8LCCD       PLccd                              CER048 BUG22578A
     C*****SDLOCN        PARM      SDLOCN        DSLDY                              CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        (PRtcd <> *BLANKS)                               CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C******LOCK         IN        LDA                                              CER048 BUG22578A
     C**********         EVAL      DBFILE = 'SDLOCNPD'                              CER048 BUG22578A
     C**********         EVAL      DBKEY = @A8LCCD                                  CER048 BUG22578A
     C**********         EVAL      DBase = 007                                      CER048 BUG22578A
     C**********         OUT       LDA                                              CER048 BUG22578A
     C**********         EXSR      SRERR                                            CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
      ***Fetch*the*Threshold*Amounts*Using*the*Country*of*Tax*Table                 CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         CALL      'AOCTTXR0'                                       CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         PARM      *BLANKS       PRtcd                              CER048 BUG22578A
     C**********         PARM      '*KEY'        POptn                              CER048 BUG22578A
     C**********         PARM      DVCNCD        WCncd                              CER048 BUG22578A
     C**********         PARM      BBCOLC        WCloc                              CER048 BUG22578A
     C*****SDCTTX        PARM      SDCTTX        DSFDY                              CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         IF        (PRtcd <> *BLANKS)                               CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C******LOCK         IN        LDA                                              CER048 BUG22578A
     C**********         EVAL      DBFILE = 'SDCTTXPD'                              CER048 BUG22578A
     C**********         EVAL      DBKEY = WCncd + WCloc                            CER048 BUG22578A
     C**********         EVAL      DBase = 008                                      CER048 BUG22578A
     C**********         OUT       LDA                                              CER048 BUG22578A
     C**********         EXSR      SRERR                                            CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ENDIF                                                      CER048 BUG22578A
      **********                                                                    CER048 BUG22578A
     C**********         ENDSR                                                      CER048 BUG22578A
      *****************************************************************             CER048 BUG22578A
      ***/EJECT*                                                                    CER048 BUG22578A
      *****************************************************************                       CER059
      *                                                               *                       CER059
      * SRWrInph - Subroutine to write details in SDINPHPD file       *                       CER059
      *                                                               *                       CER059
      * Called By - Main Processing                                   *                       CER059
      *                                                               *                       CER059
      * Calls - SRErr                                                 *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     SRWrInph      BEGSR                                                                CER059
                                                                                              CER059
      ** Get corresponding record from additional customer file                               CER059
                                                                                              CER059
     C                   CALL      'AOACUSR0'                                                 CER059
     C                   PARM      *BLANKS       PRtcd                                        CER059
     C                   PARM      '*KEY   '     POptn                                        CER059
     C                   PARM                    PCustNo                                      CER059
     C     SDACUS        PARM      SDACUS        DSLDY                                        CER059
                                                                                              CER059
     C                   IF        PRtcd <> *BLANKS                                           CER059
     C                   EVAL      DBFile =  'SDACUSPD'                                       CER059
     C                   EVAL      DBase = 005                                                CER059
     C                   EVAL      DBKey = PCustNo                                            CER059
     C                   EXSR      SRErr                                                      CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Access Branch Code for Customer                                                      CER059
                                                                                              CER059
     C                   CALL      'AOCUSTR0'                                                 CER059
     C                   PARM      *BLANKS       PRtcd                                        CER059
     C                   PARM      '*KEY'        POptn                                        CER059
     C                   PARM      PCustNo       PCustNo10                                    CER059
     C                   PARM                    PKyst                                        CER059
     C     SDCUST        PARM      SDCUST        DSSDY                                        CER059
                                                                                              CER059
     C                   IF        PRtcd <> *BLANKS                                           CER059
     C                   EVAL      DBFile =  'SDCUSTPD'                                       CER059
     C                   EVAL      DBase = 004                                                CER059
     C                   EVAL      DBKey = POptn                                              CER059
     C                   EXSR      SRErr                                                      CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   EXSR      SRCttxDet                                                  CER059
                                                                                              CER059
     C                   IF        CTCTTX = EWCTRR                                            CER059
                                                                                              CER059
     C                   IF        CTETXS = 'S' OR CTETXS = 'D'                               CER059
     C                             OR CTETXS = 'T'                                            CER059
     C                             OR (CTETXS = 'Y' AND CER069 = 'Y')                         CER069
                                                                                              CER059
      ** Check record exist in Interest Payment History File                                  CER059
                                                                                              CER059
     C     PCustNo       CHAIN     SDINPHL0                                                   CER059
                                                                                              CER059
     C                   IF        NOT %FOUND(SDINPHL0)                                       CER059
                                                                                              CER059
     C                   EVAL      TIBRCA =  BBBRCD                                           CER059
     C                   EVAL      TICUST =  PCustNo                                          CER059
     C                   EVAL      TILSSD =  *ZEROS                                           CER059
     C                   EVAL      TIPGNO =  *ZEROS                                           CER059
     C                   EVAL      TISTRQ =  *BLANKS                                          CER059
      ** Set Statement Required Flag to 'Y' if Customer is 'T'axable                        AR740756
                                                                                            AR740756
     C                   IF        AXETXS = 'T'                                             AR740756
     C                             OR (AXETXS = 'Y' AND CER069 = 'Y')                         CER069
     C                   EVAL      TISTRQ = 'Y'                                             AR740756
     C                   ELSE                                                               AR740756
     C                   EVAL      TISTRQ = 'N'                                             AR740756
     C                   ENDIF                                                              AR740756
                                                                                            AR740756
     C                   EVAL      TIUTTH =  *ZEROS                                           CER059
     C                   EVAL      TITOUT =  *ZEROS                                           CER059
                                                                                              CER059
     C                   EVAL      TICUTH = E5EXTH                                          AR740756
     C                   IF        E5JATP = 'Y'                                               CER059
     C**********         EVAL      TICUTH = EWJTTH                                   CER059 AR740756
     C                   EVAL      TIJOIN = E5CUST                                          AR740756
     C                   ELSE                                                                 CER059
     C**********         EVAL      TICUTH = EWINTH                                   CER059 AR740756
                                                                                            AR740756
      ** Check if customer is a joint account member                                        AR740756
                                                                                            AR740756
     C     E5CUST        CHAIN     SDJACCL4                                                 AR740756
     C                   IF        NOT %FOUND(SDJACCL4)                                     AR740756
     C                   EVAL      TIJOIN = *BLANKS                                         AR740756
     C                   ELSE                                                               AR740756
     C                   EVAL      TIJOIN = JCJANO                                          AR740756
     C                   ENDIF                                                              AR740756
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   WRITE     SDINPHD0                                                   CER059
                                                                                              CER059
     C*****PCustNo       CHAIN     SDTHRHL0                                          CER059 AR740756
     C     PCustNo       CHAIN     SDTHRHL3                                                 AR740756
                                                                                              CER059
     C**********         IF        NOT %FOUND(SDTHRHL0)                              CER059 AR740756
     C                   IF        NOT %FOUND(SDTHRHL3)                                     AR740756
                                                                                              CER059
     C                   IF        TICUTH <> *ZEROS                                           CER059
     C                   EVAL      TECUST = TICUST                                            CER059
     C                   EVAL      TEACTD = BJRDNB                                            CER059
     C                   EVAL      TECEXT = TICUTH                                            CER059
     C                   EVAL      TETRAD = E5EADT                                            CER059
     C                   EVAL      TETRVD = E5EVDT                                            CER059
     C                   EVAL      TETRMD = E5ETXT                                            CER059
     C                   WRITE     SDTHRHD0                                                   CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   ELSE                                                                 CER059
                                                                                              CER059
     C                   IF        TICUTH <> *ZEROS AND                                       CER059
     C                             TEACTD = BJRDNB                                            CER059
     C                   EVAL      TEACTD = BJRDNB                                            CER059
     C                   EVAL      TECEXT = TICUTH                                            CER059
     C                   EVAL      TETRAD = E5EADT                                            CER059
     C                   EVAL      TETRVD = E5EVDT                                            CER059
     C                   EVAL      TETRMD = E5ETXT                                            CER059
     C                   UPDATE    SDTHRHD0                                                   CER059
                                                                                              CER059
     C                   ELSEIF    TICUTH <> *ZEROS AND                                       CER059
     C                             TEACTD <> BJRDNB                                           CER059
                                                                                              CER059
     C                   EVAL      TECUST = TICUST                                            CER059
     C                   EVAL      TEACTD = BJRDNB                                            CER059
     C                   EVAL      TECEXT = TICUTH                                            CER059
     C                   EVAL      TETRAD = E5EADT                                            CER059
     C                   EVAL      TETRVD = E5EVDT                                            CER059
     C                   EVAL      TETRMD = E5ETXT                                            CER059
     C                   WRITE     SDTHRHD0                                                   CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   ENDIF                                                                CER059
                                                                                            AR740756
     C                   ELSE                                                               AR740756
     C                   EVAL      TICUTH = E5EXTH                                          AR740756
                                                                                            AR740756
      ** Set Statement Required Flag to 'Y' is Customer is 'T'axable                        AR740756
                                                                                            AR740756
     C                   IF        AXETXS = 'T'                                             AR740756
     C                             OR (AXETXS = 'Y' AND CER069 = 'Y')                         CER069
     C                   EVAL      TISTRQ = 'Y'                                             AR740756
     C                   ELSE                                                               AR740756
     C                   EVAL      TISTRQ = 'N'                                             AR740756
     C                   ENDIF                                                              AR740756
                                                                                            AR740756
     C                   IF        E5JATP = 'Y'                                             AR740756
     C                   EVAL      TIJOIN = E5CUST                                          AR740756
     C                   ELSE                                                               AR740756
                                                                                            AR740756
      ** Check if customer is a joint account member                                        AR740756
                                                                                            AR740756
     C     E5CUST        CHAIN     SDJACCL4                                                 AR740756
     C                   IF        NOT %FOUND(SDJACCL4)                                     AR740756
     C                   EVAL      TIJOIN = *BLANKS                                         AR740756
     C                   ELSE                                                               AR740756
     C                   EVAL      TIJOIN = JCJANO                                          AR740756
     C                   ENDIF                                                              AR740756
     C                   ENDIF                                                              AR740756
                                                                                            AR740756
     C                   UPDATE    SDINPHD0                                                 AR740756
                                                                                            AR740756
     C     E5CUST        CHAIN     SDTHRHL3                                                 AR740756
                                                                                            AR740756
     C                   IF        NOT %FOUND(SDTHRHL3)                                     AR740756
                                                                                            AR740756
     C                   EVAL      TECUST = E5CUST                                          AR740756
     C                   EVAL      TEACTD = BJRDNB                                          AR740756
     C                   EVAL      TECEXT = TICUTH                                          AR740756
     C                   EVAL      TETRAD = E5EADT                                          AR740756
     C                   EVAL      TETRVD = E5EVDT                                          AR740756
     C                   EVAL      TETRMD = E5ETXT                                          AR740756
     C                   WRITE     SDTHRHD0                                                 AR740756
                                                                                            AR740756
     C                   ELSE                                                               AR740756
                                                                                            AR740756
     C                   IF        TEACTD = BJRDNB                                          AR740756
     C                   EVAL      TEACTD = BJRDNB                                          AR740756
     C                   EVAL      TECEXT = TICUTH                                          AR740756
     C                   EVAL      TETRAD = E5EADT                                          AR740756
     C                   EVAL      TETRVD = E5EVDT                                          AR740756
     C                   EVAL      TETRMD = E5ETXT                                          AR740756
     C                   UPDATE    SDTHRHD0                                                 AR740756
                                                                                            AR740756
     C                   ELSEIF    TEACTD <> BJRDNB                                         AR740756
                                                                                            AR740756
     C                   EVAL      TECUST = E5CUST                                          AR740756
     C                   EVAL      TEACTD = BJRDNB                                          AR740756
     C                   EVAL      TECEXT = TICUTH                                          AR740756
     C                   EVAL      TETRAD = E5EADT                                          AR740756
     C                   EVAL      TETRVD = E5EVDT                                          AR740756
     C                   EVAL      TETRMD = E5ETXT                                          AR740756
     C                   WRITE     SDTHRHD0                                                 AR740756
     C                   ENDIF                                                              AR740756
                                                                                            AR740756
     C                   ENDIF                                                              AR740756
                                                                                              CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   ELSE                                                                 CER059
                                                                                              CER059
     C     PCustNo       CHAIN     SDINPHL0                                                   CER059
                                                                                              CER059
     C                   IF        %FOUND(SDINPHL0)                                           CER059
     C                   EVAL      TICUTH = *ZEROS                                            CER059
     C                   EVAL      TISTRQ = 'N'                                             AR740756
     C                   UPDATE    SDINPHD0                                                   CER059
                                                                                              CER059
     C*****PCustNo       CHAIN     SDTHRHL0                                          CER059 AR740756
     C     PCustNo       CHAIN     SDTHRHL3                                                 AR740756
                                                                                              CER059
     C**********         IF        NOT %FOUND(SDTHRHL0)                              CER059 AR740756
     C                   IF        NOT %FOUND(SDTHRHL3)                                     AR740756
                                                                                              CER059
     C                   EVAL      TECUST = TICUST                                            CER059
     C                   EVAL      TEACTD = BJRDNB                                            CER059
     C                   EVAL      TECEXT = TICUTH                                            CER059
     C                   EVAL      TETRAD = E5EADT                                            CER059
     C                   EVAL      TETRVD = E5EVDT                                            CER059
     C                   EVAL      TETRMD = E5ETXT                                            CER059
     C                   WRITE     SDTHRHD0                                                   CER059
                                                                                              CER059
     C                   ELSE                                                                 CER059
                                                                                              CER059
     C                   IF        TEACTD = BJRDNB                                            CER059
                                                                                              CER059
     C                   EVAL      TEACTD = BJRDNB                                            CER059
     C                   EVAL      TECEXT = TICUTH                                            CER059
     C                   EVAL      TETRAD = E5EADT                                            CER059
     C                   EVAL      TETRVD = E5EVDT                                            CER059
     C                   EVAL      TETRMD = E5ETXT                                            CER059
     C                   UPDATE    SDTHRHD0                                                   CER059
                                                                                              CER059
     C                   ELSE                                                                 CER059
                                                                                              CER059
     C                   EVAL      TECUST = TICUST                                            CER059
     C                   EVAL      TEACTD = BJRDNB                                            CER059
     C                   EVAL      TECEXT = TICUTH                                            CER059
     C                   EVAL      TETRAD = E5EADT                                            CER059
     C                   EVAL      TETRVD = E5EVDT                                            CER059
     C                   EVAL      TETRMD = E5ETXT                                            CER059
     C                   WRITE     SDTHRHD0                                                   CER059
                                                                                              CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                       CER059
      /EJECT                                                                                  CER059
      *****************************************************************                       CER059
      *                                                               *                       CER059
      *  SRCttxDet: Retrieve Country of Tax Details                   *                       CER059
      *                                                               *                       CER059
      *  Called By: SRInitInTx                                        *                       CER059
      *                                                               *                       CER059
      *  Calls: None                                                  *                       CER059
      *                                                               *                       CER059
      *****************************************************************                       CER059
     C     SRCttxDet     BEGSR                                                                CER059
                                                                                              CER059
     C                   CALL      'AOBRCHR0'                                                 CER059
                                                                                              CER059
     C                   PARM      *BLANKS       PRtcd                                        CER059
     C                   PARM      '*KEY'        POptn                                        CER059
     C                   PARM      BBBRCD        PBrca                                        CER059
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CER059
                                                                                              CER059
     C                   IF        (PRtcd <> *BLANKS)                                         CER059
                                                                                              CER059
     C     *LOCK         IN        LDA                                                        CER059
     C                   EVAL      DBFILE = 'SDBRCHPD'                                        CER059
     C                   EVAL      DBKEY = BBBRCD                                             CER059
     C                   EVAL      DBase = 006                                                CER059
     C                   OUT       LDA                                                        CER059
     C                   EXSR      SRERR                                                      CER059
                                                                                              CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Get the Location Code to get the country details                                     CER059
                                                                                              CER059
     C                   CALL      'AOLOCNR0'                                                 CER059
                                                                                              CER059
     C                   PARM      *BLANKS       PRtcd                                        CER059
     C                   PARM      '*KEY'        POptn                                        CER059
     C                   PARM      @A8LCCD       PLccd                                        CER059
     C     SDLOCN        PARM      SDLOCN        DSLDY                                        CER059
                                                                                              CER059
     C                   IF        (PRtcd <> *BLANKS)                                         CER059
                                                                                              CER059
     C     *LOCK         IN        LDA                                                        CER059
     C                   EVAL      DBFILE = 'SDLOCNPD'                                        CER059
     C                   EVAL      DBKEY = @A8LCCD                                            CER059
     C                   EVAL      DBase = 007                                                CER059
     C                   OUT       LDA                                                        CER059
     C                   EXSR      SRERR                                                      CER059
                                                                                              CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Fetch the Threshold Amounts Using the Country of Tax Table                           CER059
                                                                                              CER059
     C                   CALL      'AOCTTXR0'                                                 CER059
                                                                                              CER059
     C                   PARM      *BLANKS       PRtcd                                        CER059
     C                   PARM      '*KEY'        POptn                                        CER059
     C                   PARM      DVCNCD        WCncd                                        CER059
     C                   PARM      BBCOLC        WCloc                                        CER059
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        CER059
                                                                                              CER059
     C                   IF        (PRtcd <> *BLANKS)                                         CER059
                                                                                              CER059
     C     *LOCK         IN        LDA                                                        CER059
     C                   EVAL      DBFILE = 'SDCTTXPD'                                        CER059
     C                   EVAL      DBKEY = WCncd + WCloc                                      CER059
     C                   EVAL      DBase = 008                                                CER059
     C                   OUT       LDA                                                        CER059
     C                   EXSR      SRERR                                                      CER059
                                                                                              CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   ENDSR                                                                CER059
      *****************************************************************                       CER059
      /EJECT                                                                                  CER059
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Input Parameters
      ** ================

      ** Return Code
     C                   PARM                    PRetCode
                                                                                              CER059
      ** Mode                                                                                 CER059
     C                   PARM                    PMode                                        CER059
                                                                                              234227
      ** Action Code                                                                          234227
     C                   PARM                    PAction                                      234227
                                                                                              234227
      ** Customer Number                                                                      234227
     C                   PARM                    PCustNo                                      234227

      ** New Details in File Format
     C                   PARM                    NwDlFilFmt

      ** Check if CSC011 is installed

     C                   EVAL      CSC011 = 'N'

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 003
     C                   EXSR      SRERR
     C                   ENDIF

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
      *                                                                                       CER048
      ** Access Bank Details                                                                  CER048
      *                                                                                       CER048
     C                   CALL      'AOBANKR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*FIRST '     POptn                                        CER048
     C     SDBANK        PARM      SDBANK        DSFDY                                        CER048
      *                                                                                       CER048
      ** Database Error                                                                       CER048
      *                                                                                       CER048
     C                   IF        PRtcd <> *BLANKS                                           CER048
     C                   EVAL      DBFILE = 'SDBANKPD'                                        CER048
     C                   EVAL      DBASE  = 010                                               CER048
     C                   EVAL      DBKEY = POptn                                              CER048
     C                   EXSR      SRErr                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Check if CER048 is installed                                                         CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtCd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
      ** Database error                                                                       CER048
      *                                                                                       CER048
     C                   IF        PRtcd <> *BLANKS AND                                       CER048
     C                             PRtcd <> '*NRF'                                            CER048
      *                                                                                       CER048
     C                   IN        LDA                                                        CER048
     C                   EVAL      DBKey = 'CER048'                                           CER048
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER048
     C                   EVAL      DBase = 009                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      SRErr                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ENDIF                                                                CER048
                                                                                              CER069
      ** Check if CER069 is installed                                                         CER069
                                                                                              CER069
     C                   EVAL      CER069 = 'N'                                               CER069
      *                                                                                       CER069
     C                   CALLB     'AOSARDR0'                                                 CER069
     C                   PARM      *BLANKS       PRtCd                                        CER069
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER069'      PSard                                        CER069
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
      *                                                                                       CER069
      ** Database error                                                                       CER069
      *                                                                                       CER069
     C                   IF        PRtcd <> *BLANKS AND                                       CER069
     C                             PRtcd <> '*NRF'                                            CER069
      *                                                                                       CER069
     C                   IN        LDA                                                        CER069
     C                   EVAL      DBKey = 'CER069'                                           CER069
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER069
     C                   EVAL      DBase = 011                                                CER069
     C                   OUT       LDA                                                        CER069
     C                   EXSR      SRErr                                                      CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   IF        PRtcd = *BLANKS                                            CER069
     C                   EVAL      CER069 = 'Y'                                               CER069
     C                   ENDIF                                                                CER069

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErr - Exception Errors                                      *
      *                                                               *
      *****************************************************************

     C     SRErr         BEGSR

     C                   EVAL      PRetCode = '*ERROR '
     C                   EVAL      DBPGM = 'SDCCTXUPD'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP

      **  Terminate the Program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
