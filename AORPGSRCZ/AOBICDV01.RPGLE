     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Val BIC code for SNAME, CNUM or BIC')
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  AOBICDV01 - Validate BIC Code                                *
      *                                                               *
      *  Midas - Validate BIC Code for Customer Shortname, Customer   *
      *           number, BIC Code                                    *
      *           This program validates :                            *
      *              a) that the BIC code is valid OR                 *
      *              b) that the customer / shortname / account has   *
      *                 a valid BIC code.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG24741           Date 03Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 226083             Date 02Apr04               *
      *                 221760   *CREATE   Date 17Dec03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG24741 - "XXX" is automatically added in SWIFT address in  *
      *             Sender's Correspondent field                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  226083 - Correct RFTD validation errors.                     *
      *           Here, Here, when BIC file is empty, do not          *
      *           accept 8 or 11 char entry as BIC if there are       *
      *           embedded blanks!                                    *
      *  221760 - Do not validate SWIFT ID if MEBICDPD is empty.      *
      *                                                               *
      *****************************************************************
 
     FMEBICDL2  IF   E           K DISK
      * BIC Codes file, keyed by BIC number
 
     FSDCUSTL1  IF   E           K DISK
      * Customer File, keyed by customer number
 
     FSDCUSTL2  IF   E           K DISK
      * Customer File, keyed by shortname
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
     D D@BIC         E DS                  EXTNAME(MEBICDPD)
      *  BIC details
     D D@FMT         E DS                  EXTNAME(DSSDY)
      *  External Data structure to hold the outgoing record format
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CFT009
      *  Customer Details                                                       CFT009
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
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
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Check to see if there are records in MEBICDL2, if not,the entry must
      * be 8 or 11 characters long
 
     C     *LOVAL        Setll     MEBICDL2
 
     C                   Read      MEBICDL2                               90
 
     C                   If        *IN90 =*Off
     C     *Like         Define    @Type         @T2
     C                   Eval      @T2 = '*NBC'
     C                   Else
     C                   Exsr      NoValBic
     C                   Return
     C                   Endif
 
      * Check to see what type has been passed via IdIn.
      *  BIC Code = 8 characters long
      *  Shortname - chain to SDCUSTL6 (Key = Shortname)
      *  Customer number - chain to SDCUSTPD.
 
     C                   Eval      @Type = '*NRF'
 
      * See if BIC
     C                   Eval      BDBICC = IdIn
     C     BDBICC        Setll     MEBICDL2                               99
 
     C                   If        *In99=*On
     C                   Eval      @Type = '*BIC'
     C                   Else
      * Not BIC
 
      * Check if Customer Number
     C                   Eval      BBCUST=IdIn
     C     BBCUST        Setll     SDCUSTL1                               98
 
     C                   If        *In98=*On
     C                   Eval      @Type = '*NUMBER'
     C                   Else
      * Not customer number
 
      * Check if Customer Shortname
     C                   Eval      BBCSSN=IdIn
     C     BBCSSN        Setll     SDCUSTL2                               97
 
     C                   If        *In97=*On
     C                   Eval      @Type = '*SHNAME'
 
     C                   Endif
     C                   Endif
     C                   Endif
 
 
     C                   Select
 
      * If no matches, return
     C                   When      @Type='*NRF'
     C                   Return
 
      * If BIC, retrieve data and return
     C                   When      @Type='*BIC'
 
      **If*the*entered*BIC*has*no*branch,*use*branch*XXX.**************                     BUG24741
     C**********         MoveL     *BLANKS       BIC_Code          8                        BUG24741
     C**********         MoveL     *BLANKS       Branch_Code       3                        BUG24741
     C**********         If        %Subst(IdIn:9:3) = *Blanks                               BUG24741
     C**********         Eval      BIC_Code = %Subst(IdIn:1:8)                              BUG24741
     C**********         Eval      Branch_Code = 'XXX'                                      BUG24741
     C*****Full_Key      KList                                                              BUG24741
     C**********         KFld                    BIC_Code                                   BUG24741
     C**********         KFld                    Branch_Code                                BUG24741
     C*****Full_Key      Chain     MEBICDL2                           99                    BUG24741
     C**********         If        not *In99                                                BUG24741
     C**********         Eval      %Subst(IdIn:9:3) = 'XXX'                                 BUG24741
     C**********         EndIf                                                              BUG24741
     C**********         EndIf                                                              BUG24741
 
     C     BDBICC        SETLL     MEBICDL2
     C     BDBICC        READE     MEBICDL2                               99
     C                   DoW       *In99 = *Off
 
     C                   Eval      D@FMT = D@BIC
 
     C                   If        %Subst(IdIn:9:3)  =  BDBICB  Or
     C                             %Subst(IdIn:9:3)  =  *Blanks
     C                   Eval      @Type = '*BIC'
     C                   Leave
     C                   Endif
     C
     C                   If        %Subst(IdIn:9:3)  <> BDBICB   and
     C                             %Subst(IdIn:9:3)  <> *Blanks   OR
     C                             %Subst(IdIn:12:7) <> *Blanks
     C                   Eval      @Type = '*NRF'
     C                   Endif
 
     C     BDBICC        READE     MEBICDL2                               99
     C                   Enddo
 
      * If Customer Number or Shortname, ensure that the customer has a
      *    valid BIC
     C                   When      @Type='*NUMBER'
     C     BBCUST        Chain     SDCUSTL1                           98
     C                   Eval      D@FMT = SDCUST
     C                   Exsr      ChkBic
 
      * Check that if customer number entered, positions 7 - 18 are blank
     C************       IF        %Subst(IdIn:7:11) <> *Blanks                               226083
     C                   IF        %Subst(IdIn:7:12) <> *Blanks                               226083
     C                   Eval      @Type = '*NRF'
     C                   Endif
 
     C                   When      @Type='*SHNAME'
     C     BBCSSN        Chain     SDCUSTL2                           97
     C                   Eval      D@FMT = SDCUST
     C                   Exsr      ChkBic
 
      * Check that if customer short  entered, positions 7 - 18 are blank
     C***********        IF        %Subst(IdIn:11:7) <> *Blanks                               226083
     C                   IF        %Subst(IdIn:11:8) <> *Blanks                               226083
     C                   Eval      @Type = '*NRF'
     C                   Endif
 
     C                   Endsl
 
      * Entry must be 8 or 11 characters long
 
      *
     C                   If        @Type = '*NRF' And @T2 = '*NBC'
     C                   Movel(p)  IdIn          ChkChar          18
     C     ' '           Checkr    IdIn          chknum            2 0
 
     C                   If        chknum <> 8 and chknum <> 11
     C                   Eval      @Type='*NRF'
     C                   Else
     C     ' '           Scan      IdIn          chknum2           2 0                        226083
     C                   If        chknum = 8     AND                                         226083
     C                             chknum2 < 8    OR                                          226083
     C                             chknum = 11    AND                                         226083
     C                             chknum2 < 11                                               226083
     C                   Eval      @Type='*NRF'                                               226083
     C***********        Eval      @Type='*BIC'                                               226083
     C                   Endif                                                                226083
     C                   Endif
 
     C                   Endif
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkBic - Check that BIC code is valid for customer            *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ChkBic        Begsr
 
      * Have retrieved BBCSID from SDCUSTL1 / 2. Chain to MEBICDL2 to
      *  validate
 
     C                   Eval      BDBICC = BBCSID
     C     BDBICC        Chain     MEBICDL2                           96
     C                   If        *In96 = *On
     C                   Eval      RetCodeIn = '*NOBIC'
     C                   Else
     C                   Eval      RetCodeIn = '*BICFND'
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * NOVALBIC - Subroutine when MEBICDPD has no records.           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     NoValBic      Begsr
 
     C     *Like         Define    @Type         @T2
     C                   Eval      @T2 = '*NBC'
     C                   Eval      @Type = '*NRF'
 
      * Check if Customer Number
     C                   Eval      BBCUST=IdIn
     C     BBCUST        Setll     SDCUSTL1                               98
 
     C                   If        *In98=*On
     C                   Eval      @Type = '*NUMBER'
     C                   Else
      * Not customer number
 
      * Check if Customer Shortname
     C                   Eval      BBCSSN=IdIn
     C     BBCSSN        Setll     SDCUSTL2                               97
 
     C                   If        *In97=*On
     C                   Eval      @Type = '*SHNAME'
 
     C                   Endif
     C                   Endif
 
     C                   Select
 
      * If Customer Number or Shortname, ensure that the customer has a
      *    BIC.
     C                   When      @Type='*NUMBER'
     C     BBCUST        Chain     SDCUSTL1                           98
     C                   Eval      D@FMT = SDCUST
 
      * Check that if customer number entered, positions 7 - 18 are blank
     C                   IF        BBCSID = *Blanks
     C                   Eval      @Type = '*NRF'
     C                   Endif
 
      * Check that if customer number entered, BBCSID is present.
     C***********        IF        %Subst(IdIn:7:11) <> *Blanks                               226083
     C                   IF        %Subst(IdIn:7:12) <> *Blanks                               226083
     C                   Eval      @Type = '*NRF'
     C                   Endif
 
     C                   When      @Type='*SHNAME'
     C     BBCSSN        Chain     SDCUSTL2                           97
     C                   Eval      D@FMT = SDCUST
 
      * Check that if customer number entered, positions 7 - 18 are blank
     C                   IF        BBCSID = *Blanks
     C                   Eval      @Type = '*NRF'
     C                   Endif
 
      * Check that if customer short  entered, positions 7 - 18 are blank
     C***********        IF        %Subst(IdIn:11:7) <> *Blanks                               226083
     C                   IF        %Subst(IdIn:11:8) <> *Blanks                               226083
     C                   Eval      @Type = '*NRF'
     C                   Endif
 
     C                   Endsl
 
      * Entry must be 8 or 11 characters long
 
     C                   If        @Type = '*NRF' And @T2 = '*NBC'
     C                   Movel(p)  IdIn          ChkChar          18
     C     ' '           Checkr    IdIn          chknum            2 0
 
     C                   If        chknum <> 8 and chknum <> 11
     C                   Eval      @Type='*NRF'
     C                   Else
     C     ' '           Scan      IdIn          chknum2           2 0                        226083
     C                   If        chknum = 8     AND                                         226083
     C                             chknum2 < 8    OR                                          226083
     C                             chknum = 11    AND                                         226083
     C                             chknum2 < 11                                               226083
     C                   Eval      @Type='*NRF'                                               226083
     C                   Else                                                                 226083
     C                   Eval      @Type='*BIC'
     C                   Endif                                                                226083
     C                   Endif
 
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      * INPUTS
     C                   Parm                    RetCodeIn
     C                   Parm                    IdIn             18
     C                   Parm                    @Type             7
     C                   Parm                    D@FMT
 
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
