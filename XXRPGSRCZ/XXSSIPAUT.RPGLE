     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001          ')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Standing Data Auth Authorisation Shadow')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XXSSIPAUT - Midas SD Standing Data Auth Authorisation Shadow *
      *                                                               *
      *  Function:  This program performs the Update processes that   *
      *             are to be carried out on the unauthorised record  *
      *             for standing data.                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. HUT109 *CREATE      Date 14Apr20              *
      *  Prev Amend No. xxxxxx              Date ddMmmyy              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT109 - Partial upgrade of HUT020 to FBM 2.1 SP22.  Also    *
      *           upgraded the following HUT020 fixes:                *
      *           HUT020I01, HUT020I03, HUT020I08 and HUT020I09.      *
      *           Additional Authorisation Steps in SE Module         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSTDSEL1   UF A E           K DISK    COMMIT
      ** Midas SE Standard Settlement Instructions

     FXXXSEDV0  IF   E           K DISK    Rename( XXXSEDT0 : XXXSEDL0 )
      ** Midas SE Std Settlement Instructions Shadow

     FXXXSEDV1  UF   E           K DISK    COMMIT
      ** Midas SE Std Settlement Instructions Shadow

     FSTDSEA    UF   E             DISK    COMMIT
      ** Midas SE Std Settlement Instructions(AU)

     FSDAULGL2  IF   E           K DISK    RENAME(SDAULGD0:SDAULG2)
     F                                     PREFIX(X)
      ** Authorisation Log - by Key

     FSDAULGL3  UF   E           K DISK    COMMIT
      ** Authorisation Log

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

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatiCally included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

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

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** DATA STRUCTURE FOR Midas SAR Details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details

     D @MainCode     E DS                  EXTNAME(STDSED)
     D XLCD          E                     ExtFld ( LCD  )
      ** Data Structure for STDSED

     D @ShdwCode     E DS                  EXTNAME(XXXSEDPS)
      ** Stored Shadow SE Standing Data Settlement

     D UBA             DS          5000
      **  1st Record Format
     D  MAINUBA                            LIKE(@MainCode)
      ** DS for Main File

     D UPA             DS          5000
      **  2nd Record Format
     D  MAINUPA                            LIKE(@ShdwCode)
      ** DS for Shadow File

     D DSALKEY         DS            26
     D  #SBRA                         3
     D  #CSTM                         6
     D  #SIBK                         2
     D  #CYSI                         3
     D  #SMKT                         2
     D  #ITSI                         3
     D  #SPTFR                        4
     D  Filler                        3

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D SVALK1          S             20A
     D SVALK2          S             20A
     D SVALK3          S             20A
     D SVALK4          S             20A
     D SVALK5          S             20A
     D SVALK6          S             20A
     D SVALK7          S             20A
     D SVALK8          S             20A
     D SVALK9          S             20A
     D SVALK10         S             20A
     D SVAL1           S            200A
     D SVAL2           S            200A
     D SVAL3           S            200A
     D SVAL4           S            200A
     D SVAL5           S            200A
     D SVAL6           S            200A
     D SVAL7           S            200A
     D SVAL8           S            200A
     D SVAL9           S            200A
     D SVAL10          S            200A
      *
     D KALFUNC         S                   LIKE(ALFUNC)
     D KALKEY          S                   LIKE(ALKEY)
      *
     D CSD012          S              1A
     D CustNo          S                   Like( CSTM )
     D pFunc           S             21A
      *
     D pRetCode        S              7A
     D pOption         S              7A
     D pSARD           S              6A
     D pErrMsg         S              7A
     D pFile           S             10A
     D pMsgFile        S             10A
     D pINKC           S              1A
     D pINKI           S              1A
     D pINKJ           S              1A
     D pINKL           S              1A
     D pKey            S             26A
     D pActn           S              1A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                Ê
      ** ¦ Initial processing is performed automatiCally: the *INZSR is   Ê
      ** | executed at program activation.                                Ê
      ** |                                                                Ê
      ** +----------------------------------------------------------------+

     C                   ExSr      SrProcess
      *
     C                   ExSr      SrEnd

      *****************************************************************
      /EJECT
      *****************************************************************
      * SrImage - Extract before and after record images.             *
      *                                                               *
      * Called by: SrProcess                                          *
      * Calls    :                                                    *
      *****************************************************************
     C     SrImage       BegSr

      ** Access record from shadow file
     C     SSIKey1       Chain     XXXSEDV0
      *
     C                   If        not %Found( XXXSEDV0   )
     C     *LOCK         In        LDA
      *
     C                   MoveL     'XXXSEDPS'    DBFILE
     C                   MoveL     '005'         DBASE
     C                   MoveL     pKey          DBKEY
      *
     C                   Out       LDA
      *
     C                   ExSr      *PsSr
      *
     C                   Else
      * If in Amend mode:
      *      UBA will contain the Record from the Main File
      *      UPA will contain the Record from the Shadow File
     C                   If        HCHTP = 'A'
     C                   MoveL     @ShdwCode     MAINUPA
      *
     C                   ElseIf    HCHTP = 'I'
      ** If in Insert Mode:
      **      UBA will contain the Record from the Shadow File since there are no existing record
      **      in the Master File
     C                   MoveL     @ShdwCode     MAINUBA
     C                   EndIf
     C                   EndIf
      *
      ** Access record from main file
     C     SSIKey2       Chain     STDSEL1
      *
     C                   If        not %Found( STDSEL1    )
     C                             and ( HCHTP = 'A'
     C                             or    HCHTP = 'D' )
     C     *LOCK         In        LDA
      *
     C                   MoveL     'STDSED    '  DBFILE
     C                   MoveL     '001'         DBASE
     C                   MoveL     pKey          DBKEY
      *
     C                   Out       LDA
      *
     C                   ExSr      *PsSr
      *
     C                   ElseIf    %Found( STDSEL1    )
     C                             and HCHTP <> 'I'
     C                   Eval      XLCD = LCD
     C                   MoveL     @MainCode     MAINUBA
     C                   EndIf

     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRProcess - Process pending record.                           *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls    : SrUpdate SrDelete SrEnd SrImage                    *
      *****************************************************************
     C     SRProcess     BegSr

     C                   ExSr      SrImage
      *
      ** Call program SDAUTHCMP to display differences
     C                   Eval      pFunc = *Blanks
      *
     C                   CallB     'SDAUTHCMP'
     C                   Parm      *Blanks       pRetCode
     C                   Parm      'STDSED  '    pFile
     C                   Parm                    UBA
     C                   Parm                    UPA
     C                   Parm                    pKey
     C                   Parm                    pActn
      ** Command Keys
     C                   Parm                    pInKC                          F3
     C                   Parm                    pInKI                          Authorize Requested
     C                   Parm                    pInKJ                          Delete Requested
     C                   Parm                    pInKL                          F12
     C                   Parm                    pFunc
      *
      ** Exit program If Enquire or F3 or F12
     C                   If        pActn = 'E'
     C                             or pInKC = '1'
     C                             or pInKL = '1'
     C                   MoveL     pRetCode      pErrMsg
     C                   ExSr      SrEnd
     C                   EndIf
      *
      ** Authorise Requested
     C                   If        pInKI = '1' and pActn = 'X'
     C                   ExSr      SrUpdate
     C                   ExSr      SrUpdAudit
     C                   ExSr      SrDelete
     C                   EndIf
      *
      ** Delete Requested
     C                   If        pInKJ = '1' and pActn = 'D'
     C                   ExSr      SrDelete
     C                   EndIf

     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrUpdAudit - Update audit file.                               *
      *                                                               *
      * Called by: SrProcess                                          *
      * Calls    :                                                    *
      *****************************************************************
     C     SrUpdAudit    BegSr

     C     1             Chain     STDSEA
      *
     C                   If        %Found( STDSEA     )
     C                   Select
     C                   When      HCHTP = 'I'
     C                   Eval      SINS += 1
     C                   Eval      NORE += 1
     C
     C                   When      HCHTP = 'A'
     C                   Eval      SAMD += 1
     C
     C                   When      HCHTP = 'D'
     C                   Eval      SDEL += 1
     C                   Eval      NORE -= 1
     C                   EndSl
      *
     C                   Update    STDSEAF
     C                   EndIf

     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrDelete - Delete Authorisation request from Log file and     *
      *            Shadow file.                                       *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls    :                                                    *
      *****************************************************************
     C     SrDelete      BegSr

      ** Delete record from Audit Log
     C     LogKey        Chain     SDAULGL3
      *
     C                   If        not %Found( SDAULGL3   )
     C     *LOCK         In        LDA
      *
     C                   MoveL     'SDAULGPD'    DBFILE
     C                   MoveL     '006'         DBASE
     C                   MoveL     pKey          DBKEY
     C                   Move      KALFUNC       DBKEY
      *
     C                   Out       LDA
      *
     C                   ExSr      *PsSr
      *
     C                   Else
     C                   Delete    SDAULGL3
     C                   EndIf
      *
      ** Delete record from Shadow File
     C     SSIKey1       Chain     XXXSEDV1
      *
     C                   If        %Found( XXXSEDV1   )
     C                   Delete    XXXSEDT0
     C                   EndIf
      *
      * Commit Changes
     C                   Commit

     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrUpdate - Update Master File with Shadow File details        *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls    : SrMove                                             *
      *****************************************************************
     C     SrUpdate      BegSr

      ** Access the Master File
     C     SSIKey2       Chain     STDSEL1
      *
     C                   Select
      ** Insert the record
     C                   When      HCHTP = 'I'
     C                   If        not %Found( STDSEL1    )
     C                             or   ( %Found( STDSEL1    )
     C                             and  RECI = '*' )
     C                   Clear                   STDSEDF
      *
     C                   ExSr      SrMove
      *
     C                   If        not %Found( STDSEL1    )
     C                   Write     STDSEDF
     C
     C                   Else
     C                   Update    STDSEDF
     C                   EndIf
     C                   EndIf
      *
      ** Delete the record
     C                   When      HCHTP = 'D'
     C                   If        %Found( STDSEL1    )
     C                   Eval      CHTP   = 'D'
     C                   Eval      RECI   = '*'
     C                   Update    STDSEDF
     C                   EndIf
      *
      ** Amend the record
     C                   When      HCHTP = 'A'
     C                   If        %Found( STDSEL1    )
     C                   ExSr      SrMove
      *
     C                   Update    STDSEDF
     C                   EndIf
     C                   EndSl

     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrMove - Move Fields                                          *
      *                                                               *
      * Called by: SrUpdate                                           *
      * Calls    : None                                               *
      *****************************************************************
     C     SrMove        BegSr

     C                   Eval      RECI   = HRECI
     C                   Eval      SBRA   = HSBRA
     C                   Move      HCSTM         CSTM
     C                   Eval      CYSI   = HCYSI
     C                   Eval      ITSI   = HITSI
     C                   Eval      SRSM   = HSRSM
     C                   Eval      SRACQQ = HSRACQ
     C                   Eval      SRAB   = HSRAB
     C                   Eval      SRCB   = HSRCB
     C                   Eval      SPSM   = HSPSM
     C                   Eval      SPATQQ = HSPATQ
     C                   Eval      SPBA   = HSPBA
     C                   Eval      SPCB   = HSPCB
     C                   Eval      SPFA   = HSPFA
     C                   Eval      SPSI   = HSPSI
     C                   Eval      SPCP   = HSPCP
     C                   Eval      SPCS   = HSPCS
     C                   Eval      SCLP   = HSCLP
     C                   Eval      SCLS   = HSCLS
     C                   Eval      SCLH   = HSCLH
     C                   Move      HSDTO         SDTO
     C                   Move      HSDFO         SDFO
     C                   Move      HSDTT         SDTT
     C                   Eval      SFAT   = HSFAT
     C                   Move      HSDFT         SDFT
     C                   Eval      SFAF   = HSFAF
     C                   Eval      LCD    = HLCD
     C                   Eval      CHTP   = HCHTP
     C                   Eval      TNLU   = HTNLU
     C                   Eval      SCCY   = HSCCY
     C                   Eval      ERII   = HERII
     C                   Eval      SKAC   = HSKAC
     C                   Eval      SIBK   = HSIBK
     C                   Eval      SPTFR  = HSPTFR
     C                   Eval      SNEW   = HSNEW
     C                   Eval      STFDM  = HSTFDM
     C                   Eval      SMKT   = HSMKT
     C                   Eval      SASI   = HSASI
     C                   Eval      SRAC   = HSRAC
     C                   Eval      SPAT   = HSPAT

     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrEnd - End Program                                           *
      *                                                               *
      * Called by: Main rOutine                                       *
      * Calls    : None                                               *
      *****************************************************************
     C     SrEnd         BegSr

      ** Terminate program
     C                   Eval      *InLR = *On
      *
      ** Exit program
     C                   Return

     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation ROutine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *  Calls    :                                                   *
      *****************************************************************
     C     *INZSR        BegSr

      ** Define Keylist
     C     LogKey        KList
     C                   KFld                    KALFUNC
     C                   KFld                    KALKEY
      *
      ** key list for shadow file XXXSEDPS
     C     SSIKey1       KList
     C                   KFld                    #SBRA
     C                   KFld                    #CSTM
     C                   KFld                    #SIBK
     C                   KFld                    #CYSI
     C                   KFld                    #SMKT
     C                   KFld                    #ITSI
     C                   KFld                    #SPTFR
      *
      ** key list for main file STDSED
     C     SSIKey2       KList
     C                   KFld                    #SBRA
     C                   KFld                    CustNo
     C                   KFld                    #SIBK
     C                   KFld                    #CYSI
     C                   KFld                    #SMKT
     C                   KFld                    #ITSI
     C                   KFld                    #SPTFR
      *
      ** Receive entry parameters
     C     *ENTRY        PList
     C                   Parm                    pRetCode
     C                   Parm                    pKey
     C                   Parm                    pActn
     C                   Parm                    pErrMsg
     C                   Parm                    pMsgFile
     C                   Parm                    pInKC
      *
      ** Define LDA
     C     *LOCK         In        LDA
     C                   Eval      DBPGM = 'XXSSIPAUT'
     C                   Eval      DBFILE = *Blanks
     C                   Eval      DBKEY =  *Blanks
     C                   Out       LDA
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
     C                   Call      'AOBANKR0'
     C                   Parm      '*MSG   '     pRetCode
     C                   Parm      '*FIRST '     pOption
     C     SDBANK        Parm      SDBANK        DSSDY
      *
      ** Handle Database Error.
     C                   If        pRetCode <> *Blanks
     C     *LOCK         In        LDA
      *
     C                   Move      'SDBANKPD'    DBFILE
     C                   MoveL     pOption       DBKEY
     C                   Move      '001'         DBASE
     C                   MoveL     'SDE217'      DBPGM
      *
     C                   Out       LDA
      *
     C                   ExSr      *PsSr
     C                   EndIf
      *
      ** Access SAR details file to determine If CSD012
      ** (Standing Data Authorisation) is on.
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       pRetCode
     C                   Parm      '*VERIFY'     pOption
     C                   Parm      'CSD012'      pSARD
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C                   If        pRetCode = *Blanks
     C                   Move      'Y'           CSD012
      *
     C                   Else
     C                   Move      'N'           CSD012
     C                   EndIf
      *
      ** If CSD012 is ON, Check If Customer Details Authorisation is ON
     C                   If        CSD012 = 'Y'
     C                   Eval      SVALK1 = 'AuthReqSESSIMaint'
     C                   Call      'AOSVALR0'
     C                   Parm      *Blanks       pRetCode
     C                   Parm                    SVALK1
     C                   Parm                    SVAL1
     C                   Parm                    SVALK2
     C                   Parm                    SVAL2
     C                   Parm                    SVALK3
     C                   Parm                    SVAL3
     C                   Parm                    SVALK4
     C                   Parm                    SVAL4
     C                   Parm                    SVALK5
     C                   Parm                    SVAL5
     C                   Parm                    SVALK6
     C                   Parm                    SVAL6
     C                   Parm                    SVALK7
     C                   Parm                    SVAL7
     C                   Parm                    SVALK8
     C                   Parm                    SVAL8
     C                   Parm                    SVALK9
     C                   Parm                    SVAL9
     C                   Parm                    SVALK10
     C                   Parm                    SVAL10
      *
     C                   If        @RTCD <> *Blanks
     C     *LOCK         In        LDA
      *
     C                   Move      'SDSVALPD'    DBFILE
     C                   MoveL     SVALK1        DBKEY
     C                   Move      '002'         DBASE
     C                   MoveL     'XXSSIPAUT'   DBPGM
      *
     C                   Out       LDA
      *
     C                   ExSr      *PsSr
     C                   EndIf
     C                   EndIf
      *
      ** End the program If any of the condition is met
     C                   If        CSD012 <> 'Y'
     C                             or %SubSt( SVAL1 : 1 : 1 ) <> 'Y'
     C                   ExSr      SrEnd
     C                   EndIf
      *
      ** Initialize Before and After Update File Parameter
     C                   Clear                   UBA
     C                   Clear                   UPA
      *
      ** Access record from authorisation log
     C                   Eval      KALFUNC = 'SE STD SETTLEMNT INST'
     C                   Eval      KALKEY  = pKey
      *
     C     LogKey        Chain     SDAULGL2
      *
     C                   If        not %Found( SDAULGL2   )
     C     *LOCK         In        LDA
      *
     C                   MoveL     'SDAULGPD'    DBFILE
     C                   MoveL     '003'         DBASE
     C                   MoveL     pKey          DBKEY
     C                   Move      KALFUNC       DBKEY
      *
     C                   Out       LDA
      *
     C                   ExSr      *PsSr
     C                   EndIf
      *
     C                   Eval      DSALKEY = pKey
     C                   Move      #CSTM         CustNo

     C                   EndSr
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
