     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Val BIC code for SNAME, CNUM or BIC')
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  AOBICDV0 - Validate BIC Code                                 *
      *                                                               *
      *  Midas - Validate BIC Code for Customer Shortname, Customer   *
      *           number, BIC Code                                    *
      *           This program validates :                            *
      *              a) that the BIC code is valid OR                 *
      *              b) that the customer / shortname / account has   *
      *                 a valid BIC code.                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 05Jun00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184168             Date 28Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 15Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *           Program based on this module was created for the    *
      *           use of OPM programs.                                *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  184168 - Ensure that if BIC found the remaining characters   *
      *           are blank                                           *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
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
     C     *Like         Define    @Type         @T2                            CFT009
     C                   Eval      @T2 = '*NBC'                                 CFT009
     C                   Endif                                                  CFT009
 
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
                                                                                 CFT009
      * If the entered BIC has no branch, use branch XXX.                        CFT009
     C                   MoveL     *BLANKS       BIC_Code          8             CFT009
     C                   MoveL     *BLANKS       Branch_Code       3             CFT009
     C                   If        %Subst(IdIn:9:3) = *Blanks                    CFT009
     C                   Eval      BIC_Code = %Subst(IdIn:1:8)                   CFT009
     C                   Eval      Branch_Code = 'XXX'                           CFT009
     C     Full_Key      KList                                                   CFT009
     C                   KFld                    BIC_Code                        CFT009
     C                   KFld                    Branch_Code                     CFT009
     C     Full_Key      Chain     MEBICDL2                           99         CFT009
     C                   If        not *In99                                     CFT009
     C                   Eval      %Subst(IdIn:9:3) = 'XXX'                      CFT009
     C                   EndIf                                                   CFT009
     C                   EndIf                                                   CFT009
                                                                                 CFT009
     C*****BDBICC        Chain     MEBICDL2                           99         184168
     C     BDBICC        SETLL     MEBICDL2                                      184168
     C     BDBICC        READE     MEBICDL2                               99     184168
     C                   DoW       *In99 = *Off                                  184168
                                                                                 184168
     C                   Eval      D@FMT = D@BIC
 
     C                   If        %Subst(IdIn:9:3)  =  BDBICB  Or               184168
     C                             %Subst(IdIn:9:3)  =  *Blanks                  184168
     C                   Eval      @Type = '*BIC'                                184168
     C                   Leave                                                   184168
     C                   Endif                                                   184168
     C                                                                           184168
     C                   If        %Subst(IdIn:9:3)  <> BDBICB   and             184168
     C                             %Subst(IdIn:9:3)  <> *Blanks   OR             184168
     C                             %Subst(IdIn:12:7) <> *Blanks                  184168
     C                   Eval      @Type = '*NRF'                                184168
     C                   Endif                                                   184168
                                                                                 184168
     C     BDBICC        READE     MEBICDL2                               99     184168
     C                   Enddo                                                   184168
 
      * If Customer Number or Shortname, ensure that the customer has a
      *    valid BIC
     C                   When      @Type='*NUMBER'
     C     BBCUST        Chain     SDCUSTL1                           98
     C                   Eval      D@FMT = SDCUST                                CFT009
     C                   Exsr      ChkBic
 
      * Check that if customer number entered, positions 7 - 18 are blank        184168
     C                   IF        %Subst(IdIn:7:11) <> *Blanks                  184168
     C                   Eval      @Type = '*NRF'                                184168
     C                   Endif                                                   184168
 
     C                   When      @Type='*SHNAME'
     C     BBCSSN        Chain     SDCUSTL2                           97
     C                   Eval      D@FMT = SDCUST                                CFT009
     C                   Exsr      ChkBic
 
      * Check that if customer short  entered, positions 7 - 18 are blank        184168
     C                   IF        %Subst(IdIn:11:7) <> *Blanks                  184168
     C                   Eval      @Type = '*NRF'                                184168
     C                   Endif                                                   184168
 
     C                   Endsl
 
      * Entry must be 8 or 11 characters long
 
     C*******************Else                                                   CFT009
      *                                                                         CFT009
     C                   If        @Type = '*NRF' And @T2 = '*NBC'              CFT009
     C                   Movel(p)  IdIn          ChkChar          18
     C     ' '           Checkr    IdIn          chknum            2 0
 
     C                   If        chknum <> 8 and chknum <> 11
     C                   Eval      @Type='*NRF'
     C                   Else
     C                   Eval      @Type='*BIC'
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
     C*******************Eval      D@FMT = D@BIC                               CFT009
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
(c) Finastra International Limited 2001
