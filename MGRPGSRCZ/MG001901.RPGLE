     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Extended Narrative validation program')          *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  MG001901 - Extended Narrative Validation ,Formatting program *
      *                                                               *
      *  Function : This program validates, formats the extended      *
      *             narrative input based on the Network Account      *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD062385           Date 07Mar24               *
      *  Prev Amend No. MD062339           Date 21Feb24               *
      *                 BA6020             Date 12Feb23               *
      *                 BA6026             Date 18Jan23               *
      *                 CMG008             Date 20Feb20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD044271           Date 21Mar17               *
      *                 MD000091           Date 14May13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26840           Date 11Dec09               *
      *                 BUG26511           Date 29Oct09               *
      *                 BUG26435           Date 20Oct09               *
      *                 BUG25476           Date 13Aug09               *
      *                 BUG24303           Date 18Jun09               *
      *                 BUG24278           Date 16Jun09               *
      *                 BUG24300           Date 10Jun09               *
      *                 BUG24069           Date 08Jun09               *
      *                 BUG24304           Date 12Jun09               *
      *                 BUG23742*CREATE    Date 09May09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062385 - Implement MP1.4 missing fixes MD054381/MD055334.  *
      *             Changes to be conditioned on CSW101 (GSH018 was   *
      *             upgraded to FM2021F as CSW101).                   *
      *  MD055334 - Referencing case 02149005 and remaining issues    *
      *             of the fix - Amend the condition of checking      *
      *             if GSH018 is ON introduced by MD054381. SWIFT     *
      *             A/cs with more than 390 extended narratives       *
      *             must be accepted.                                 *
      *  MD054381 - Receiving transaction data in Midas batch         *
      *             interface - Add checking of feature GSH018 in     *
      *             validation of extended narrative.                 *
      *  MD062339- BA6026 - upgrade of extra parts to FM 2021         *
      *  BA6020 - Add Specific header field to CM XML Output          *
      *  BA6026 - Structuring Current MT940 and SEPA Compliance.      *
      *           Add structured formatting for Field 86.             *
      *           Include GSH026, GSH041, GSH046 and Change Requests  *
      *  GSH046CC2 - Structured MT940 Automated Process CC2           *
      *  GSH046CC1 - Structured MT940 Automated Process CC1           *
      *  GSH046 - Structured MT940 Automated process                  *
      *  GSH041A -  Added Field 86 Address Change to WKSF86 <> 'Y'    *
      *             i.e. not using keywords                           *
      *  GSH041 - GSH026 Field 86 Address Change                      *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044271 - (1) if MT940 is not to be generated, default      *
      *             network to PAPER                                  *
      *             (2) allow ':' as valid character for PAPER network*
      *  MD000091 - Event Codes Substitution                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26840 - 22x35 EN is not in the advice                     *
      *  BUG26511 - SWIFT MT940 incorrectly formats MTcash Narratives *
      *  BUG26435 - Serious Midas Error occurs when Multicash         *
      *             Narrative is used                                 *
      *  BUG25476 - MT940 rejected by MMM                             *
      *  BUG24303 - No validation on max lines in Multicash Narrative *
      *             fields                                            *
      *  BUG24278 - Improper handling of /IACC/Dn indicator           *
      *  BUG24300 - No validation for mandatory multicash narrative   *
      *             fields 1, 2, 3 and 18                             *
      *  BUG24069 -  /IACC indicator not removed when network is not  *
      *              Multicash                                        *
      *  BUG24304 - Error reformatting to STRCT format                *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR     - Initialisation Subroutine                       *
      *  SRNwrk     - Get the Format type using the Network           *
      *  SRValidate - Validate the Format of the Extended Narrative   *
      *  SRNoChar   - Validate the No of Characters to be present     *
      *               in the Extended Narrative                       *
      *  SRFormat   - Formatting the Input (22*35) according to the   *
      *               definition at network level                     *
      *  SRFmt      - Process for the Formatting of extended          *
      *               narratives without separatrors                  *
      *  SrFnNet    - Find default network linked to transaction      *
      *  SRNarr     - Extract narratives in proper form for           *
      *               formatting                                      *
      *  SrLnVal    - Check Multicash Narrative allowed lines         *                     BUG24303
      *  *PSSR      - Error processing                                *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Midas GL Network Accounts - MT94x
      *
     FGLNW94L11 IF   E           K DISK
      *
     FGLNW94L8  IF   E           K DISK    RENAME(GLNW94D0:GLNW94D1)
      *
     FA6RETRL1  IF   E           K DISK                                                       BA6026
     FA6NW94L0  IF   E           K DISK    RENAME(A6NW94D0:A6NW94D1)                          BA6026
     F                                     PREFIX(Z_)                                         BA6026
      *                                                                                       BA6026
     FA6H940L0  IF   E           K DISK                                                       BA6026
     FA6M940L0  IF   E           K DISK                                                       BA6026
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes the definitions
      ** for error and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures. They have meaningful
      ** names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array for storing extended narratives names in error
      *
     D ArrExtName      S              6A   DIM(22) CTDATA PERRCD(1)
      *
      ** Array for storing extended narratives Lengths
      *
     D ArrLen22        S              2  0 DIM(22) CTDATA PERRCD(1)
      *
      ** Array for storing extended narratives
      *
     D ArrExt          S             35A   DIM(22)
      *
      ** Array for storing extended narratives
      *
     D PArrExt22       S             35A   DIM(22)
      *
      ** Array for storing extended narratives in format 22 * 70
      *
     D PArrCc1         S             35A   DIM(50)                                            BA6026
      *                                                                                       BA6026
      ** Array for storing Narratives                                                         BA6026
      *
     D Arr22           S             70A   DIM(22)
      *                                                                                       BA6026
      ** Array for TRF Unstructured REMI (Incoming)                                           BA6026
     D TRFUnstInc      S              5A   DIM(40)                                            BA6026
      *                                                                                       BA6026
      ** Array for TRF Unstructured REMI (Outgoing)                                         MD062339
     D TRFUnstOut      S              5A   DIM(40)                                          MD062339
      *                                                                                     MD062339
      ** Array for TRF Structured REMI (Incoming)                                             BA6026
     D TRFStrucInc     S              5A   DIM(40)                                            BA6026
      *                                                                                     MD062339
      ** Array for TRF Structured REMI (Outgoing)                                           MD062339
     D TRFStrucOut     S              5A   DIM(40)                                          MD062339
      *                                                                                     MD062339
      ** Array for RTI (Incoming)                                                           MD062339
     D RTIInc          S              5A   DIM(40)                                          MD062339
      *                                                                                     MD062339
      ** Array for RTI (Outgoing)                                                           MD062339
     D RTIOut          S              5A   DIM(40)                                          MD062339
      *                                                                                     MD062339
      ** Array for CHG (Both Incoming and Outgoing)                                         MD062339
     D CHGIncOut       S              5A   DIM(40)                                          MD062339
      *
      ** Network details record format data structure
      *
     D DSNwrk        E DS                  EXTNAME(SDNWRKPD)
      *
     D DSNwrkN       E DS                  EXTNAME(SDNWRKPD)
     D                                     PREFIX(N_)
      *
      ** Long Access Object Data Structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
                                                                                              BA6020
      ** Externally described DS for SAR Details                                              BA6020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  BA6020
                                                                                              BA6020
      ** DS for Access Programs - short data structure                                        BA6020
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     BA6020
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Program Parameters
      *
     D PRtcd           S             10A
     D POptn           S              7A
     D PNwrk           S              6A
     D PMsgTyp         S              3A
     D PBrca           S              3A
     D*PCNum****       S              6  0                                                    CER059
     D PCNum           S              6A                                                      CER059
     D PCcy            S              3A
     D PAccd           S             10S 0
     D PAcsq           S              2S 0
     D PDCInd          S              1A
     D PTranTp         S              5A
     D PPNarr          S             30A                                                      BA6026
     D PNaty           S              1A                                                      BA6026
     D PDstn           S             11A                                                      BA6026
     D PFormL1         S             70A
     D PFormL2         S             70A
     D PFormL3         S             70A
     D PFormL4         S             70A
     D PFormL5         S             70A
     D PFormL6         S             70A
     D PFormL7         S             70A
     D PFormL8         S             70A
     D PFormL9         S             70A
     D PFormL10        S             70A
     D PFormL11        S             70A
     D PFormL12        S             70A
     D PFormL13        S             70A
     D PFormL14        S             70A
     D PFormL15        S             70A
     D PFormL16        S             70A
     D PFormL17        S             70A
     D PFormL18        S             70A
     D PFormL19        S             70A
     D PFormL20        S             70A
     D PFormL21        S             70A
     D PFormL22        S             70A
      *
      ** Key List Parameters
      *
     D KBrca           S                   LIKE(N4BRCA)
     D KCNum           S                   LIKE(N4CNUM)
     D KCcy            S                   LIKE(N4CCY)
     D KAccd           S                   LIKE(N4ACCD)
     D KAcsq           S                   LIKE(N4ACSQ)
      *
     D KNwrk           S                   LIKE(EDNWRK)
     D KNwrk1          S                   LIKE(EDNWRK)
      *
      ** Work Variables
      *
     D WExtNarr        S            770A
     D WExt            S            770A
     D WString         S            770A
     D WNarr           S            770A
     D WTmp            S            770A
     D WLenIn          S              3S 0
     D WStart          S              3S 0
     D WStartPos       S              3S 0
     D WPs             S              3S 0
     D WNoChar         S              3S 0
     D WLIdx           S              3S 0
     D WError          S              1A
     D Idx             S              3  0
     D WNwLine         S              5I 0
     D WRem            S              5I 0
     D WInd            S              2  0
     D WIndA           S              2A
     D WIndx           S              2  0
     D WIndx1          S              2  0
     D WRemain         S              3S 0
     D WExt046         S            770A                                                      BA6026
     D WWrk046         S            770A                                                      BA6026
     D Pos             S              5S 0                                                    BA6026
     D DivRslt         S              3S 0                                                    BA6026
     D DivRmdr         S              3S 0                                                    BA6026
     D RmdgBlk         S              3S 0                                                    BA6026
     D FillBlanks      S            999A                                                      BA6026
      *
     D POptnIn         S              7A
     D PRtcdIn         S              7A
     D PNwrkIn         S              6A
     D WLenNarr        S              3S 0
     D WFmtFlg         S              1A
     D WStrct          S              1A
     D WIdx            S              2S 0
     D WPosCl          S              3S 0
     D WLnCnt          S              2S 0                                                  BUG24303
     D WCtr            S              2S 0                                                  BUG24303
      ** Work fields for AOSARDR0                                                             BA6026
     D POptnAO         S              7A                                                      BA6026
     D PSardAO         S              6A                                                      BA6026
     D PRtcdAO         S              7A                                                      BA6026
     D BA6026          S              1A                                                      BA6026
      ** Work fields for AOSVALR0                                                             BA6026
     D SVALK1          C                   'TTyp_TRF_UnstREMIInc'                             BA6026
     D SVALK2          C                   'TTyp_TRF_UnstREMIOut'                           MD062339
     D*SVALK2****      C                   'TTyp_TRF_StrREMIInc'                      BA6026MD062339
     D SVALK3          C                   'TTyp_TRF_StrREMIInc'                            MD062339
     D SVALK4          C                   'TTyp_TRF_StrREMIOut'                            MD062339
     D SVALK5          C                   'TTyp_RTI_Incoming'                              MD062339
     D SVALK6          C                   'TTyp_RTI_Outgoing'                              MD062339
     D SVALK7          C                   'TTyp_CHG_Inc_Out'                               MD062339
     D*SVALK3****      C                   'A6Fld86AddChg'                            BA6026MD062339
     D SVALK8          C                   'A6Fld86AddChg'                                  MD062339
     D SVOP01          S             20A                                                      BA6026
     D SVVL01          S            200A                                                      BA6026
     D SVOP02          S             20A                                                      BA6026
     D SVVL02          S            200A                                                      BA6026
     D SVOP03          S             20A                                                      BA6026
     D SVVL03          S            200A                                                      BA6026
     D SVOP04          S             20A                                                      BA6026
     D SVVL04          S            200A                                                      BA6026
     D SVOP05          S             20A                                                      BA6026
     D SVVL05          S            200A                                                      BA6026
     D SVOP06          S             20A                                                      BA6026
     D SVVL06          S            200A                                                      BA6026
     D SVOP07          S             20A                                                      BA6026
     D SVVL07          S            200A                                                      BA6026
     D SVOP08          S             20A                                                      BA6026
     D SVVL08          S            200A                                                      BA6026
     D SVOP09          S             20A                                                      BA6026
     D SVVL09          S            200A                                                      BA6026
     D SVOP10          S             20A                                                      BA6026
     D SVVL10          S            200A                                                      BA6026
      *                                                                                       BA6026
      ** Work fields for Fld 86 formatting                                                    BA6026
     D Len             S              1S 0                                                    BA6026
     D Str             S              3S 0                                                    BA6026
     D Z               S              2S 0                                                    BA6026
     D FMTMode         S              5A                                                      BA6026
     D WENarrNew       S            770A                                                    MD062339
     D WENarrNew2      S            123A                                                    MD062339
     D WAdded          S              1A                                                    MD062339
     D WKBENM          S             80A                                                    MD062339
     D WKORDP          S             80A                                                    MD062339
     D WKIBAN          S             45A                                                    MD062339
     D WKBENB          S             45A                                                    MD062339
     D WKORDB          S             45A                                                    MD062339
     D WKREMI          S            160A                                                    MD062339
     D WKEREF          S             45A                                                    MD062339
     D WKCHGS          S             45A                                                    MD062339
     D WKOCMT          S             45A                                                    MD062339
     D WKEXCH          S             45A                                                    MD062339
     D WKTRTP          S             45A                                                    MD062339
     D WKRTRN          S             45A                                                    MD062339
     D WKSF86          S              1A                                                      BA6026
     D ChkFound        S              1A                                                      BA6026
     D CheckL1         S             70A                                                    MD062339
     D CheckL2         S             70A                                                    MD062339
     D CheckL3         S             70A                                                    MD062339
     D CheckL4         S             70A                                                    MD062339
     D CheckL5         S             70A                                                    MD062339
     D CheckL6         S             70A                                                    MD062339
     D CheckL7         S             70A                                                    MD062339
     D CheckL8         S             70A                                                    MD062339
     D CheckL9         S             70A                                                    MD062339
     D CheckL10        S             70A                                                    MD062339
     D CheckL11        S             70A                                                    MD062339
     D CheckL12        S             70A                                                    MD062339
     D MapDet          S              1A                                                      BA6026
      *                                                                                       BA6026
      ** Key fields for KAcct2 (for CHAIN to A6NW94L0)                                        BA6026
     D KNetw2          S                   LIKE(N4NWRK)                                       BA6026
     D KBrca2          S                   LIKE(N4BRCA)                                       BA6026
     D KCnum2          S                   LIKE(N4CNUM)                                       BA6026
     D KCcy2           S                   LIKE(N4CCY)                                        BA6026
     D KAccd2          S                   LIKE(N4ACCD)                                       BA6026
     D KAcsq2          S                   LIKE(N4ACSQ)                                       BA6026
     D KNaty2          S                   LIKE(N4NATY)                                       BA6026
     D KDstn2          S                   LIKE(N4DSTN)                                       BA6026
      *                                                                                       BA6026
      ** Work fields for System Values                                                        BA6026
     D A6Fld86AddChg   S              1A                                                      BA6026
     D CSW101          S              1A                                                    MD062385
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   EVAL      WExtNarr = PArrExt22(1) + PArrExt22(2)+
     C                                        PArrExt22(3) + PArrExt22(4)+
     C                                        PArrExt22(5) + PArrExt22(6)+
     C                                        PArrExt22(7) + PArrExt22(8)+
     C                                        PArrExt22(9) + PArrExt22(10)+
     C                                        PArrExt22(11) + PArrExt22(12)+
     C                                        PArrExt22(13) + PArrExt22(14)+
     C                                        PArrExt22(15) + PArrExt22(16)+
     C                                        PArrExt22(17) + PArrExt22(18)+
     C                                        PArrExt22(19) + PArrExt22(20)+
     C                                        PArrExt22(21) + PArrExt22(22)
      *
      ** If Ext. narr. are blank, no need for further processing
      *
     C                   IF        WExtNarr = *BLANKS
     C                   EVAL      PFormL1 = *BLANKS                                        BUG24304
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   EXSR      SRNwrk
      *
      **  Validate the input format of 22 *35 using network details
      *
     C                   IF        POptn = '*VALID'
     C                   EXSR      SRValidate
      *
      ** In case of any error set the return code to '*ERROR'
      *
     C                   IF         WError = 'Y'
     C                   EVAL       PRtcd = '*ERROR'
     C                   ELSE
     C                   EVAL       PRtcd = *BLANKS
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Formatting 6*65 according to formatting options
      **  using network details
      *
     C                   IF        POptn = '*FORMAT'
      *
      ** Call the external program for additional formatting
      *
     C                   IF        EDEXFM <> '*NONE' AND
     C                             EDEXFM <> *BLANKS
     C                   CALL      EDEXFM
     C                   PARM                    PRtcd
     C                   PARM                    POptn
     C                   PARM                    PNwrk
     C                   PARM                    PMsgTyp
     C                   PARM                    PBrca
     C                   PARM                    PCNum
     C                   PARM                    PCcy
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PDCInd
     C                   PARM                    PTranTp
     C                   PARM                    PArrExt22
     C                   PARM                    PFormL1
     C                   PARM                    PFormL2
     C                   PARM                    PFormL3
     C                   PARM                    PFormL4
     C                   PARM                    PFormL5
     C                   PARM                    PFormL6
     C                   PARM                    PFormL7
     C                   PARM                    PFormL8
     C                   PARM                    PFormL9
     C                   PARM                    PFormL10
     C                   PARM                    PFormL11
     C                   PARM                    PFormL12
     C                   PARM                    PFormL13
     C                   PARM                    PFormL14
     C                   PARM                    PFormL15
     C                   PARM                    PFormL16
     C                   PARM                    PFormL17
     C                   PARM                    PFormL18
     C                   PARM                    PFormL19
     C                   PARM                    PFormL20
     C                   PARM                    PFormL21
     C                   PARM                    PFormL22
     C                   PARM                    Idx
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
     C                   ELSE
      *
     C                   EXSR      SrFnNet
      *
     C                   If        BA6026 = 'Y'                                               BA6026
     C                             and PMsgTyp = '940' and PNwrk = 'SWIFT'                    BA6026
      *                                                                                       BA6026
     C                   Eval      MapDet = *Blanks                                           BA6026
      *                                                                                       BA6026
     C     PTranTp       Chain     A6RETRL1                           70                      BA6026
      *                                                                                       BA6026
     C                   Eval      K1Trat = PTranTp                                           BA6026
     C                   Eval      K1Swid = G1Sidc                                            BA6026
      *                                                                                       BA6026
     C     K1M940        Chain     A6H940L0                           80                      BA6026
     C     *In80         Ifeq      *Off                                                       BA6026
     C                   Eval      MapDet = 'Y'                                               BA6026
     C                   else                                                                 BA6026
     C                   Eval      K1Trat = *Blanks                                           BA6026
     C     K1M940        Chain     A6H940L0                           80                      BA6026
     C     *In80         Ifeq      *Off                                                       BA6026
     C                   Eval      MapDet = 'Y'                                               BA6026
     C                   Endif                                                                BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
      ** If BA6026 is ON and Structured Fld 86 to be formatted for SWIFT MT940s               BA6026
     C                   If        BA6026 = 'Y' and PMsgTyp = '940'                           BA6026
     C                             and PNwrk = 'SWIFT' and WKSF86 = 'Y'                       BA6026
     C                             and G1SIDC <> *Blanks and G1SIDC <> 'NMSC'                 BA6026
     C                             and MapDet = 'Y'                                           BA6026
     C                             Or BA6026 = 'Y' and PMsgTyp = '940'                      MD062339
     C                             and PNwrk = 'SWIFT' and WKSF86 = 'Y'                     MD062339
     C                             and MapDet <> 'Y'                                        MD062339
     C                   If        MapDet = 'Y'                                             MD062339
     C                   Exsr      SrFmt046                                                   BA6026
     C                   Else                                                               MD062339
     C                   Exsr      SrFmtNew                                                 MD062339
     C                   Endif                                                              MD062339
     C                   Else                                                                 BA6026
     C                   EXSR      SrNarr
      *
     C                   EXSR      SRFormat
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   EVAL      PRtcd = '*FORMAT'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNwrk - Get the Format type using the Network               *
      *                                                               *
      *****************************************************************
     C     SRNwrk        BEGSR
      *
      ** When Network is blanks get the network from Network accounts
      ** file using the Account
      *
     C                   IF        PNwrk = *BLANKS
     C                   EVAL      KBrca = PBrca
     C                   EVAL      KCNum = PCNum
     C                   EVAL      KCcy = PCcy
     C                   EVAL      KAccd = PAccd
     C                   EVAL      KAcsq = PAcsq
      *
      ** When Account is not present then use the default 'SWIFT'
      *
     C     KAcct         CHAIN     GLNW94L11
      *
     C                   IF        NOT %FOUND (GLNW94L11)
      *
     C     KAcct         CHAIN     GLNW94L8
     C                   IF        NOT %FOUND (GLNW94L8)
      ** If MT940 is not to be generated, default network to PAPER                          MD044271
     C**********         EVAL      KNwrk = 'SWIFT'                                          MD044271
     C                   EVAL      KNwrk = 'PAPER'                                          MD044271
     C                   ELSE
      *
      ** Loop to get First network with Extended naarative flag as 'Y'
      *
     C                   DOW       NOT %EOF(GLNW94L8)
     C                   EVAL      KNwrk = N4NWRK
      *
     C                   CALL      'AONWRKR1'
     C                   PARM      *BLANKS       PRtCdIn
     C                   PARM      '*KEY'        POptnIn
     C                   PARM      KNwrk         PNwrkIn
     C     DSNwrk        PARM                    DSLDY
      *
     C                   IF        PRtCdIn <> *BLANKS
      *
     C     *LOCK         IN        LDA
      *
     C                   EVAL      DBASE = 998
     C                   EVAL      DBFILE = 'SDNWRKPD'
     C                   EVAL      DBKEY  = KNwrk
     C                   EVAL      DBPGM = 'MG001900'
      *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        EDENRA <> 'Y'
     C     KAcct         READE     GLNW94L8
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      KNwrk = N4NWRK
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      KNwrk = PNwrk
     C                   ENDIF
      *
      ** Retrieve the associated network record and find the format
      ** related to the network else issue an error
      *
     C                   CALL      'AONWRKR1'
     C                   PARM      *BLANKS       PRtCdIn
     C                   PARM      '*KEY'        POptnIn
     C                   PARM      KNwrk         PNwrkIn
     C     DSNwrk        PARM                    DSLDY
      *
     C                   IF        PRtCdIn <> *BLANKS
      *
      ** If network was defaulted to PAPER and does not exist, return                       MD044271
     C                   IF        KNwrk = 'PAPER'                                          MD044271
     C                   EVAL      *INLR = *ON                                              MD044271
     C                   RETURN                                                             MD044271
     C                   ENDIF                                                              MD044271
                                                                                            MD044271
     C     *LOCK         IN        LDA
      *
     C                   EVAL      DBASE = 999
     C                   EVAL      DBFILE = 'SDNWRKPD'
     C                   EVAL      DBKEY  = KNwrk
     C                   EVAL      DBPGM = 'MG001900'
      *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Return if extended narrative flag for the network is not 'Y'
      *
     C                   IF        EDENRA <> 'Y'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Change No. of lines/chars as per the indicator of /IACC/Dn
      *
     C                   IF        POptn = '*FORMAT'
     C                             AND EDMCNW = 'Y'
     C**********                   AND PDCInd = '1'                                         BUG24278
     C**********         EVAL      EDNOLN = 06                                              BUG24278
     C**********         EVAL      EDNCLN = 65                                              BUG24278
     C                   SELECT                                                             BUG24278
      *                                                                                     BUG24278
     C                   WHEN      PDCInd = '0'                                             BUG24278
     C                   EVAL      EDNOLN = 14                                              BUG24278
     C                   EVAL      EDNCLN = 27                                              BUG24278
      *                                                                                     BUG24278
     C                   WHEN      PDCInd = '1'                                             BUG24278
     C                   EVAL      EDNOLN = 06                                              BUG24278
     C                   EVAL      EDNCLN = 65                                              BUG24278
      *                                                                                     BUG24278
     C                   WHEN      PDCInd = '2'                                             BUG24278
     C                   EVAL      EDNOLN = 10                                              BUG24278
     C                   EVAL      EDNCLN = 32                                              BUG24278
      *                                                                                     BUG24278
     C                   WHEN      PDCInd = '3'                                             BUG24278
     C                   EVAL      EDNOLN = 16                                              BUG24278
     C                   EVAL      EDNCLN = 35                                              BUG24278
      *                                                                                     BUG24278
     C                   ENDSL                                                              BUG24278
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate the Format of the Extended Narrative   *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
      *
     C                   EVAL      WStart = 1
     C                   EVAL      WLIdx = 1
     C                   EVAL      WError = 'N'
     C                   EVAL      WInd  = 1
     C                   EVAL      WIndx1 = 1
      *
      ** ':' is not a valid character for multicash network
      *
     C                   IF        EDMCNW = 'Y'
      *
     C                   DO        22
     C                   EVAL      WPosCl = *ZEROS
     C                   EVAL      WPosCl = %SCAN(':' :PArrExt22(WInd):1)
      *
     C                   IF        WPosCl > *ZEROS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WInd)
     C                   EVAL      MsgIDXAr(Idx) = 'USR5304'
     C                   EVAL      WError = 'Y'
     C                   ENDIF
      *
     C                   EVAL      WInd = WInd + 1
     C                   ENDDO
      *
     C                   IF        WError = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ELSE                                                               BUG25476
                                                                                            BUG25476
      ** ':' is not a valid character if it is the first character                          BUG25476
      ** in the line                                                                        BUG25476
      ** allow ':' as first character if PAPER netwok                                       MD044271
     C                   IF        EDNWRK <> 'PAPER'                                        MD044271
                                                                                            BUG25476
     C                   DO        22                                                       BUG25476
     C                   EVAL      WPosCl = *ZEROS                                          BUG25476
     C                   EVAL      WPosCl = %SCAN(':' :PArrExt22(WInd):1)                   BUG25476
      *                                                                                     BUG25476
     C                   IF        WPosCl = 1                                               BUG25476
     C                   EVAL      Idx = Idx + 1                                            BUG25476
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WInd)                        BUG25476
     C                   EVAL      MsgIDXAr(Idx) = 'USR5306'                                BUG25476
     C                   EVAL      WError = 'Y'                                             BUG25476
     C                   ENDIF                                                              BUG25476
      *                                                                                     BUG25476
     C                   EVAL      WInd = WInd + 1                                          BUG25476
     C                   ENDDO                                                              BUG25476
      *                                                                                     BUG25476
     C                   IF        WError = 'Y'                                             BUG25476
     C                   LEAVESR                                                            BUG25476
     C                   ENDIF                                                              BUG25476
     C                   ENDIF                                                              MD044271
      *                                                                                     BUG25476
     C                   ENDIF
      *
     C                   If        CSW101 = 'Y'                                             MD062385
     C                   LEAVESR                                                            MD062385
     C                   Endif                                                              MD062385
      *
      ** If network/format is 'SWIFT' then the max chars allowed is 390
      *
     C                   IF        EDNWRK = 'SWIFT' OR EDF86F ='SWIFT'
     C                             OR CSW101 = 'N'                                          MD062385
      *
     C                   EVAL      WExt = %TRIM(PArrExt22(1)) +
     C                                        %TRIM(PArrExt22(2))+
     C                                        %TRIM(PArrExt22(3))+
     C                                        %TRIM(PArrExt22(4))+
     C                                        %TRIM(PArrExt22(5))+
     C                                        %TRIM(PArrExt22(6))+
     C                                        %TRIM(PArrExt22(7))+
     C                                        %TRIM(PArrExt22(8))+
     C                                        %TRIM(PArrExt22(9))+
     C                                        %TRIM(PArrExt22(10))+
     C                                        %TRIM(PArrExt22(11))+
     C                                        %TRIM(PArrExt22(12))+
     C                                        %TRIM(PArrExt22(13))+
     C                                        %TRIM(PArrExt22(14))+
     C                                        %TRIM(PArrExt22(15))+
     C                                        %TRIM(PArrExt22(16))+
     C                                        %TRIM(PArrExt22(17))+
     C                                        %TRIM(PArrExt22(18))+
     C                                        %TRIM(PArrExt22(19))+
     C                                        %TRIM(PArrExt22(20))+
     C                                        %TRIM(PArrExt22(21))+
     C                                        %TRIM(PArrExt22(22))
      *
     C                   EVAL      WLenIn =  %LEN(%TRIM(WExt))
     C                   IF        WLenIn > 390
      *
     C                   EVAL      WLenNarr = %LEN(%TRIMR(WExtNarr))
      *
     C                   EVAL      WNwLine = %DIV (WLenNarr : 35)
     C                   EVAL      WRem = %REM (WLenNarr : 35)
     C                   IF        WRem > *ZEROS
     C                   EVAL      WNwLine = WNwLine + 1
     C                   ENDIF
      *
     C                   EVAL      WInd  = 1                                                BUG26435
      *                                                                                     BUG26435
     C                   DO        WNwLine
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WInd)
     C                   EVAL      MsgIDXAr(Idx) = 'USR5302'
      *
     C                   EVAL      WInd = WInd + 1
     C                   ENDDO
      *
     C                   EVAL      WError = 'Y'
     C                   ENDIF
      *                                                                                     BUG24303
     C                   EXSR      SrLnVal                                                  BUG24303
      *
     C                   ELSE
      *
     C                   IF        EDNOLN > 1
      *                                                                                     BUG24303
     C                   EVAL      WInd = 1                                                 BUG24303
      *
      ** Get Number of lines in extended narratives
      *
     C                   DOW       WInd < 23
     C                   EVAL      WNoChar = %LEN(%TRIM(PArrExt22(WInd)))
     C                   IF        WNoChar > *ZEROS
     C                   EVAL      WLIdx = WLIdx + 1
      *
      ** No Of lines in the Extended Narrative is greater than no of
      ** lines at Network Level
      *
     C                   IF        (WLIdx -1) > EDNOLN
      *
     C                   EVAL      WLenNarr = %LEN(%TRIMR(WExtNarr))
      *
     C                   EVAL      WNwLine = %DIV (WLenNarr : 35)
     C                   EVAL      WRem = %REM (WLenNarr : 35)
     C                   IF        WRem > *ZEROS
     C                   EVAL      WNwLine = WNwLine + 1
     C                   ENDIF
      *
     C                   DO        WNwLine
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WIndx1)
     C                   EVAL      MsgIDXAr(Idx) = 'USR5301'
     C                   EVAL      WIndx1 = WIndx1 + 1
     C                   ENDDO
      *
     C                   EVAL      WError = 'Y'
      *
      ** If error occurs , don't do any further processing
      *
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
     C                   EVAL      WInd = WInd + 1
     C                   ENDDO
      *
      ** Calculating no of chars/lines for extended narrative 1 - 22
      *
     C                   EVAL      WInd = 1
      *
     C                   DO        22
     C                   EVAL      WNoChar = %LEN(%TRIM(PArrExt22(WInd)))
      *
      ** Check for error if No. of chars is greater than network level
      *
     C                   IF        WNoChar > EDNCLN
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WInd)
     C                   EVAL      MsgIDXAr(Idx) = 'USR5302'
     C                   EVAL      WError = 'Y'
     C                   ENDIF
      *
     C                   EVAL      WInd = WInd + 1
     C                   ENDDO
      *
     C                   ELSE
      *
      ** No. of lines at network level is 1
      *
     C                   EXSR      SrStVal
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRStVal - Validate the No of Characters to be present        *
      *             in the Extended Narrative for STRCT format        *
      *                                                               *
      *****************************************************************
     C     SRStVal       BEGSR
      *                                                                                     BUG24300
      ** Field 1, 2, 3 and 18 are mandatory                                                 BUG24300
      *                                                                                     BUG24300
     C                   IF        PArrExt22(1) = *BLANKS                                   BUG24300
     C                   EVAL      Idx = Idx + 1                                            BUG24300
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(1)                           BUG24300
     C                   EVAL      MsgIDXAr(Idx) = 'USR5305'                                BUG24300
     C                   EVAL      WError = 'Y'                                             BUG24300
     C                   ENDIF                                                              BUG24300
      *                                                                                     BUG24300
     C                   IF        PArrExt22(2) = *BLANKS                                   BUG24300
     C                   EVAL      Idx = Idx + 1                                            BUG24300
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(2)                           BUG24300
     C                   EVAL      MsgIDXAr(Idx) = 'USR5305'                                BUG24300
     C                   EVAL      WError = 'Y'                                             BUG24300
     C                   ENDIF                                                              BUG24300
      *                                                                                     BUG24300
     C                   IF        PArrExt22(3) = *BLANKS                                   BUG24300
     C                   EVAL      Idx = Idx + 1                                            BUG24300
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(3)                           BUG24300
     C                   EVAL      MsgIDXAr(Idx) = 'USR5305'                                BUG24300
     C                   EVAL      WError = 'Y'                                             BUG24300
     C                   ENDIF                                                              BUG24300
      *                                                                                     BUG24300
     C                   IF        PArrExt22(18) = *BLANKS                                  BUG24300
     C                   EVAL      Idx = Idx + 1                                            BUG24300
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(18)                          BUG24300
     C                   EVAL      MsgIDXAr(Idx) = 'USR5305'                                BUG24300
     C                   EVAL      WError = 'Y'                                             BUG24300
     C                   ENDIF                                                              BUG24300
      *                                                                                     BUG24300
     C                   EVAL      WInd = 1
     C                   DO        22
     C                   EVAL      WNoChar = %LEN(%TRIM(PArrExt22(WInd)))
     C                   IF        WNoChar > ArrLen22(WInd)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WInd)
     C                   EVAL      MsgIDXAr(Idx) = 'USR5303'
     C**********         MOVEL     ArrLen22(WInd)MsgDtaXAr(Idx)                             MD000091
     C                   MOVE      ArrLen22(WInd)MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) =LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   MOVEL     WInd          WIndA
     C                   EVAL      %SUBST(MsgDtaXAr(Idx):3:2) = WIndA
     C                   EVAL      WError = 'Y'
     C                   ENDIF
     C                   EVAL      WInd = WInd + 1
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************                     BUG24303
      /EJECT                                                                                BUG24303
      *****************************************************************                     BUG24303
      *                                                               *                     BUG24303
      *  SrLnVal    - Check Multicash Narrative allowed lines         *                     BUG24303
      *                                                               *                     BUG24303
      *****************************************************************                     BUG24303
     C     SrLnVal       BEGSR                                                              BUG24303
      *                                                                                     BUG24303
     C                   EVAL      WLnCnt = 1                                               BUG24303
     C                   EVAL      WCtr = 0                                                 BUG24303
      *                                                                                     BUG24303
     C                   DO        22                                                       BUG24303
     C                   IF        %trim(PArrExt22(WLnCnt)) <> *blanks                      BUG24303
     C                   EVAL      WCtr = WCtr + 1                                          BUG24303
      *                                                                                       BA6020
     C     BA6020        IFEQ      'N'                                                        BA6020
      *                                                                                       BA6020
     C                   IF        WCtr > EDNOLN                                            BUG24303
     C                   EVAL      Idx = Idx + 1                                            BUG24303
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WLnCnt)                      BUG24303
     C                   EVAL      MsgIDXAr(Idx) = 'USR5335'                                BUG24303
     C**********         EVAL      MsgDtaXAr(Idx)= %CHAR(EDNOLN)                   BUG24303 MD000091
     C                   EVAL      MsgDtaTmp = %CHAR(EDNOLN)                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) =LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   EVAL      WError = 'Y'                                             BUG24303
     C                   ENDIF                                                              BUG24303
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6020
     C                   ENDIF                                                              BUG24303
     C                   EVAL      WLnCnt = WLnCnt + 1                                      BUG24303
     C                   ENDDO                                                              BUG24303
      *                                                                                     BUG24303
     C                   ENDSR                                                              BUG24303
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFormat - Formatting the Input (22*35) according the        *
      *             definition at network level                       *
      *                                                               *
      *****************************************************************
     C     SRFormat      BEGSR
      *
     C                   EVAL      WStartPos = 1
     C                   EVAL      WLIdx = 1
     C                   EVAL      WIdx = 1
     C                   EVAL      WStart = 1
      *
     C**********         IF        WStrct = 'Y'                                             BUG24304
     C**********         DO        22                                                       BUG24304
     C**********         EVAL      Arr22(WIdx) = %SUBST(ParrExt22(Widx):1                   BUG24304
     C**********                                 :Arrlen22(WIdx))                           BUG24304
     C**********         EVAL      WIdx = WIdx + 1                                          BUG24304
     C**********         ENDDO                                                              BUG24304
      **********                                                                            BUG24304
     C**********         ELSE                                                               BUG24304
     C                   IF        WFmtFlg = 'Y'
      *
     C                   IF        EDTRLN ='Y'
     C                   EVAL      WTmp = WExtNarr
      *
      ** If /IACC/D indicator is used then write new extended narrative 1
      *
     C                   IF        WPs > *ZEROS
     C                   EVAL      %SUBST(WTmp:1:35) = PArrExt22(1)
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      WTmp = WNarr
     C                   ENDIF
      *
     C                   EXSR      SRFmt
     C                   ENDIF
     C**********         ENDIF                                                              BUG24304
      *
      ** Set output params
      *
     C                   EVAL      PFormL1 = Arr22(1)
     C                   EVAL      PFormL2 = Arr22(2)
     C                   EVAL      PFormL3 = Arr22(3)
     C                   EVAL      PFormL4 = Arr22(4)
     C                   EVAL      PFormL5 = Arr22(5)
     C                   EVAL      PFormL6 = Arr22(6)
     C                   EVAL      PFormL7 = Arr22(7)
     C                   EVAL      PFormL8 = Arr22(8)
     C                   EVAL      PFormL9 = Arr22(9)
     C                   EVAL      PFormL10 = Arr22(10)
     C                   EVAL      PFormL11 = Arr22(11)
     C                   EVAL      PFormL12 = Arr22(12)
     C                   EVAL      PFormL13 = Arr22(13)
     C                   EVAL      PFormL14 = Arr22(14)
     C                   EVAL      PFormL15 = Arr22(15)
     C                   EVAL      PFormL16 = Arr22(16)
     C                   EVAL      PFormL17 = Arr22(17)
     C                   EVAL      PFormL18 = Arr22(18)
     C                   EVAL      PFormL19 = Arr22(19)
     C                   EVAL      PFormL20 = Arr22(20)
     C                   EVAL      PFormL21 = Arr22(21)
     C                   EVAL      PFormL22 = Arr22(22)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmt - Process for the Formatting of extended narratives    *
      *          without separatrors                                  *
      *                                                               *
      *****************************************************************
     C     SRFmt         BEGSR
      *
      *
     C                   EVAL      WStartPos = 1
     C                   IF        EDF86F = 'STRCT' AND N_EDF86F = 'STRCT'                  BUG26840
     C                   EVAL      WRemain = ArrLen22(WLIdx)                                BUG26840
     C                   ELSE                                                               BUG26840
     C                   EVAL      WRemain = EDNCLN
     C                   ENDIF                                                              BUG26840
      *                                                                                     BUG26840
     C                   IF        EDF86F = 'STRCT' AND EDNOLN = 1                          BUG26840
     C                   EVAL      EDNOLN = 22                                              BUG26840
     C                   EVAL      EDNCLN = 34                                              BUG26840
     C                   ENDIF                                                              BUG26840
      *
     C                   IF        EDWTXT = 'Y'
      *
     C                   DOW       WLIdx <=  EDNOLN AND WStartPos < 770
      *
     C                   IF        %SUBST(WTmp :WStartPos) =  *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *
      ** If the remaining characters are less than the number of
      ** characters per line, use the remaining characters instead
      *
     C                   IF        EDF86F = 'STRCT' AND N_EDF86F = 'STRCT'                  BUG26840
     C                   IF        WRemain < ArrLen22(WLIdx)                                BUG26840
     C                   EVAL      Arr22(WLIdx) =                                           BUG26840
     C                             %SUBST(WTmp: WStartPos)                                  BUG26840
     C                   ELSE                                                               BUG26840
     C                   EVAL      Arr22(WLIdx) =                                           BUG26840
     C                             %SUBST(WTmp: WStartPos:ArrLen22(WLIdx))                  BUG26840
     C                   ENDIF                                                              BUG26840
     C                   ELSE                                                               BUG26840
     C                   IF        WRemain < EDNCLN
     C                   EVAL      Arr22(WLIdx) =
     C                             %SUBST(WTmp: WStartPos: WRemain + 1)
     C                   ELSE
     C                   EVAL      Arr22(WLIdx) =
     C                             %SUBST(WTmp: WStartPos: EDNCLN)
     C                   ENDIF
     C                   ENDIF                                                              BUG26840
      *
     C                   EVAL      WLIdx = WLIdx + 1
     C                   IF        EDF86F = 'STRCT' AND N_EDF86F = 'STRCT'                  BUG26840
     C                   EVAL      WStartPos = WStartPos + ArrLen22(WLIdx)                  BUG26840
     C                   ELSE                                                               BUG26840
     C                   EVAL      WStartPos = WStartPos + EDNCLN
     C                   ENDIF                                                              BUG26840
     C                   EVAL      WRemain   = 770 - WStartPos
     C                   ENDDO
      *
     C                   ELSE
     C                   DOW       WLIdx <=  EDNOLN AND WStartPos < 770
      *
     C                   IF        %SUBST(WTmp :WStartPos) =  *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      WString = %SUBST(WTmp :WStartPos : 35)
      *
     C                   IF        WString <> *BLANKS
     C                   EVAL      Arr22(WLIdx) =
     C                             %SUBST(WString: 1: EDNCLN)
     C                   EVAL      WLIdx = WLIdx + 1
     C                   ENDIF
      *
     C                   EVAL      WStartPos = WStartPos + 35
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFnNet - Find default network linked to transaction         *
      *                                                               *
      *  Called by : Main                                             *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrFnNet       BEGSR
      *
     C                   IF        PFormL1 <> *BLANKS
     C                   MOVEL     PFormL1       KNwrk1
     C                   EVAL      PFormL1 = *BLANKS                                        BUG24304
     C                   ELSE
     C                   EVAL      KBrca = PBrca
     C                   EVAL      KCNum = PCNum
     C                   EVAL      KCcy = PCcy
     C                   EVAL      KAccd = PAccd
     C                   EVAL      KAcsq = PAcsq
      *
      ** When Account is not present then use the default 'SWIFT'
      *
     C     KAcct         CHAIN     GLNW94L11
      *
     C                   IF        NOT %FOUND (GLNW94L11)
      *
     C     KAcct         CHAIN     GLNW94L8
     C                   IF        NOT %FOUND (GLNW94L8)
     C                   EVAL      KNwrk1= 'SWIFT'
      *                                                                                       BA6026
      ** Set Structured Fld 86 flag to off.                                                   BA6026
     C                   EVAL      WKSF86 = 'N'                                               BA6026
     C                   ELSE
      *
      ** Loop to get First network with Extended naarative flag as 'Y'
      *
     C                   DOW       NOT %EOF(GLNW94L8)
     C                   EVAL      KNwrk1= N4NWRK
      *
     C                   CALL      'AONWRKR1'
     C                   PARM      *BLANKS       PRtCdIn
     C                   PARM      '*KEY'        POptnIn
     C                   PARM      KNwrk1        PNwrkIn
     C     DSNwrkN       PARM                    DSLDY
      *
     C                   IF        PRtCdIn <> *BLANKS
      *
     C     *LOCK         IN        LDA
      *
     C                   EVAL      DBASE = 003
     C                   EVAL      DBFILE = 'SDNWRKPD'
     C                   EVAL      DBKEY  = KNwrk1
     C                   EVAL      DBPGM = 'MG001901'
      *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        EDENRA <> 'Y'
     C     KAcct         READE     GLNW94L8
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      KNwrk1= N4NWRK
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Retrieve the associated network record and find the format
      ** related to the network else issue an error
      *
     C                   CALL      'AONWRKR1'
     C                   PARM      *BLANKS       PRtCdIn
     C                   PARM      '*KEY'        POptnIn
     C                   PARM      KNwrk1        PNwrkIn
     C     DSNwrkN       PARM                    DSLDY
      *
     C                   IF        PRtCdIn <> *BLANKS
      *
     C     *LOCK         IN        LDA
      *
     C                   EVAL      DBASE = 004
     C                   EVAL      DBFILE = 'SDNWRKPD'
     C                   EVAL      DBKEY  = KNwrk1
     C                   EVAL      DBPGM = 'MG001901'
      *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       BA6026
      ** Retrieve the value of Structured Field 86 flag for this account.                     BA6026
     C                   If        BA6026 = 'Y'                                               BA6026
      *                                                                                       BA6026
      ** Load key values for retrieval of extension record.                                   BA6026
     C                   Eval      KNetw2 = PNwrk                                             BA6026
     C                   Eval      KBrca2 = PBrca                                             BA6026
     C                   Eval      KCnum2 = PCNum                                             BA6026
     C                   Eval      KCcy2 = PCcy                                               BA6026
     C                   Eval      KAccd2 = PAccd                                             BA6026
     C                   Eval      KAcsq2 = PAcsq                                             BA6026
     C                   Eval      KNaty2 = PNaty                                             BA6026
     C                   Eval      KDstn2 = PDstn                                             BA6026
      *                                                                                       BA6026
      ** Retrieve network account details extension.                                          BA6026
     C     KAcct2        Chain     A6NW94L0                                                   BA6026
     C                   If        NOT %FOUND (A6NW94L0)                                      BA6026
     C                   Eval      WKSF86 = 'N'                                               BA6026
     C                   Else                                                                 BA6026
     C                   Eval      WKSF86 = Z_G4SF86                                          BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   Endif                                                                BA6026
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNarr - Extract narratives in proper form for formatting    *
      *                                                               *
      *  Called by : Main                                             *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
     C     SrNarr        BEGSR
     C                   EVAL      WNarr = *BLANKS
      *
     C                   EVAL      WNarr=  WExtNarr
      *
      ** If /IACC/Dn indicator used in data remove it  from Pnarr1
      *
     C**********         IF        PDCInd = '1'                                             BUG24278
     C                   IF        (PDCInd = '0' OR PDCInd = '1' OR                         BUG24278
     C                             PDCInd = '2' OR PDCInd = '3')                            BUG24278
     C**********                   AND EDMCNW = 'Y'                                         BUG24069
     C**********         EVAL      WPs = %SCAN('/IACC/D1':PArrExt22(1))                     BUG24278
     C                   EVAL      WPs = %SCAN('/IACC/D':PArrExt22(1))                      BUG24278
      *
     C                   IF        WPs > *ZEROS
     C                   EVAL      PArrExt22(1) = %REPLACE('':PArrExt22(1)
     C                                            :WPs:8)
     C                   ENDIF
     C                   ENDIF
      *
      ** Initialize formatting flag
      *
     C                   EVAL      WFmtFlg = 'N'
     C**********         EVAL      WStrct = 'N'                                             BUG24304
     C                   EVAL      WIndx = 1
     C                   EVAL      WLIdx = 1
     C                   EVAL      WNoChar = *ZEROS
     C                   EVAL      WStart = 1
      *
     C                   IF        EDF86F = 'STRCT' AND N_EDF86F <> 'STRCT'
     C**********                   AND WPs = 0                                              BUG24069
     C                             AND ( WPs = 0  OR EDMCNW = 'N' )                         BUG24069
     C**********         EVAL      WStrct ='Y'                                              BUG24304
     C                   EVAL      EDNOLN = 16                                              BUG24304
     C                   EVAL      EDNCLN = 27                                              BUG24304
     C                   ENDIF                                                              BUG24304
     C**********         ELSE                                                               BUG24304
      *
      ** Get Number of lines/chars in extended narratives
      *
     C                   DOW       WIndx < 23
     C                   EVAL      WNoChar = %LEN(%TRIM(PArrExt22(WIndx)))
      *
     C                   IF        WNoChar > *ZEROS
     C                   EVAL      WLIdx = WLIdx + 1
      *
      ** If input no. of lines/chars is greater than requesting n/w's max len/chars
      ** then formatting is required.
      *
     C                   IF        (WLIdx -1) > EDNOLN OR
     C                             WNoChar > EDNCLN
      *
     C                   EVAL      WFmtFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      WIndx = WIndx + 1
     C                   ENDDO
      *                                                                                       BA6026
     C                   If        BA6026 = 'Y'                                               BA6026
     C                             And A6Fld86AddChg = 'Y'                                    BA6026
      *                                                                                       BA6026
      ** Look up in arrays of Transaction Types to determine                                  BA6026
      ** formatting type                                                                      BA6026
      *                                                                                       BA6026
     C                   Eval      FMTMode = *blanks                                          BA6026
     C     PTranTp       Lookup    TRFUnstInc                             99                  BA6026
      *                                                                                       BA6026
     C                   If        *IN99 = *ON                                                BA6026
     C                   Eval      FMTMode = 'TRFUI'                                          BA6026
     C                   Else                                                                 BA6026
     C     PTranTp       Lookup    TRFStrucInc                            99                  BA6026
      *                                                                                       BA6026
     C                   If        *IN99 = *ON                                                BA6026
     C                   Eval      FMTMode = 'TRFSI'                                          BA6026
     C                   Endif                                                                BA6026
     C                   Endif                                                                BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
      *
      ** Check if formatting required
      *
     C**********         IF        ((N_EDNOLN = EDNOLN) AND (N_EDNCLN = EDNCLN))            BUG26511
     C                   IF        (EDF86F <> 'STRCT' AND EDNWRK <> N_EDNWRK                BUG26511
     C                             AND N_EDNOLN = EDNOLN AND N_EDNCLN = EDNCLN)             BUG26511
     C                             OR WFmtFlg = 'N'
     C                   EVAL      WFmtFlg = 'N'
      *
     C                   EVAL      WIdx = 1
      *                                                                                       BA6026
     C                   DO        22
     C                   IF        BA6026 = 'Y'                                               BA6026
     C                             And A6Fld86AddChg = 'Y'                                    BA6026
     C                             And (FMTMode = 'TRFUI'                                     BA6026
     C                             Or FMTMode = 'TRFSI')                                      BA6026
      *                                                                                       BA6026
     C                   IF        (WIdx = 1 OR WIdx > 4)                                     BA6026
     C                   EVAL      Arr22(WIdx) = ParrExt22(WIdx)                              BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
      ** BA6026 Off or ON but not Incoming Payments                                           BA6026
      *                                                                                       BA6026
     C                   Else                                                                 BA6026
                                                                                              BA6026
     C                   EVAL      Arr22(WIdx) = ParrExt22(WIdx)
     C                   Endif                                                                BA6026
     C                   EVAL      WIdx = WIdx + 1
     C                   ENDDO
      *
      ** Else format the narratives as requested.
      *
     C                   ELSE
      *
      ** If Wrap Text for requesting network is 'Y'
      *
     C                   IF        EDWTXT = 'Y'
      *
     C                   EVAL      WNarr = *BLANKS
      *
     C                   If        BA6026 = 'Y'                                               BA6026
     C                             And A6Fld86AddChg = 'Y'                                    BA6026
     C                             And (FMTMode = 'TRFUI'                                     BA6026
     C                             Or FMTMode = 'TRFSI')                                      BA6026
      *                                                                                       BA6026
      ** limit format to Incoming payments                                                    BA6026
      *                                                                                       BA6026
     C                   EVAL      WNarr = %TRIM(PArrExt22(1))+ '  '+                         BA6026
     C                                     %TRIM(PArrExt22(5))+ '  '+                         BA6026
     C                                     %TRIM(PArrExt22(6))+ '  '+                         BA6026
     C                                     %TRIM(PArrExt22(7))+ '  '+                         BA6026
     C                                     %TRIM(PArrExt22(8))+ '  '+                         BA6026
     C                                     %TRIM(PArrExt22(9))+ '  '+                         BA6026
     C                                     %TRIM(PArrExt22(10))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(11))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(12))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(13))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(14))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(15))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(16))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(17))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(18))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(19))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(20))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(21))+ '  '+                        BA6026
     C                                     %TRIM(PArrExt22(22)) + '  '                        BA6026
     C                   Else                                                                 BA6026
                                                                                              BA6026
      * use previous formatting                                                               BA6026
                                                                                              BA6026
     C                   EVAL      WNarr = %TRIM(PArrExt22(1))+ '  '+
     C                                     %TRIM(PArrExt22(2))+ '  '+
     C                                     %TRIM(PArrExt22(3))+ '  '+
     C                                     %TRIM(PArrExt22(4))+ '  '+
     C                                     %TRIM(PArrExt22(5))+ '  '+
     C                                     %TRIM(PArrExt22(6))+ '  '+
     C                                     %TRIM(PArrExt22(7))+ '  '+
     C                                     %TRIM(PArrExt22(8))+ '  '+
     C                                     %TRIM(PArrExt22(9))+ '  '+
     C                                     %TRIM(PArrExt22(10))+ '  '+
     C                                     %TRIM(PArrExt22(11))+ '  '+
     C                                     %TRIM(PArrExt22(12))+ '  '+
     C                                     %TRIM(PArrExt22(13))+ '  '+
     C                                     %TRIM(PArrExt22(14))+ '  '+
     C                                     %TRIM(PArrExt22(15))+ '  '+
     C                                     %TRIM(PArrExt22(16))+ '  '+
     C                                     %TRIM(PArrExt22(17))+ '  '+
     C                                     %TRIM(PArrExt22(18))+ '  '+
     C                                     %TRIM(PArrExt22(19))+ '  '+
     C                                     %TRIM(PArrExt22(20))+ '  '+
     C                                     %TRIM(PArrExt22(21))+ '  '+
     C                                     %TRIM(PArrExt22(22)) + '  '
     C                   Endif                                                                BA6026
     C
      *
      ** Move the string back to original variables
      *
     C                   ENDIF
     C                   ENDIF
      *
     C**********         ENDIF                                                              BUG24304
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  BA6026
      *****************************************************************                       BA6026
      *                                                               *                       BA6026
      *  SrFmt046 - Format Field 86 via Automated Structured Process  *                       BA6026
      *                                                               *                       BA6026
      *  Called by : Main                                             *                       BA6026
      *                                                               *                       BA6026
      *  Calls : None                                                 *                       BA6026
      *                                                               *                       BA6026
      *****************************************************************                       BA6026
     C     SrFmt046      BEGSR                                                                BA6026
      *                                                                                       BA6026
     C                   Eval      WExt046 = *Blanks                                          BA6026
     C                   Eval      FillBlanks = *Blanks                                       BA6026
      *                                                                                       BA6026
     C     K1M940        Setll     A6M940L0                                                   BA6026
     C                   Read      A6M940L0                               80                  BA6026
      *                                                                                       BA6026
     C     *In80         Doweq     *Off                                                       BA6026
     C     MPSwid        andeq     K1Swid                                                     BA6026
     C     MPTrat        andeq     K1Trat                                                     BA6026
      *                                                                                       BA6026
     C                   Eval      PArrCc1 = *Blanks                                          BA6026
     C                   Move      *Blanks       Skip1             1                          BA6026
     C                   Move      *Blanks       Skip2             1                          BA6026
     C                   Move      *Blanks       Skip3             1                          BA6026
     C                   Move      *Blanks       Skip4             1                          BA6026
      *                                                                                       BA6026
     C                   If        MPNex1 <> 0                                                BA6026
     C                   If        MPNex1 = 50                                                BA6026
     C                   Eval      PArrCc1(MPNex1) = PPNar2                                   BA6026
     C                   else                                                                 BA6026
     C                   Eval      PArrCc1(MPNex1) = PArrExt22(MPNex1)                        BA6026
     C                   Endif                                                                BA6026
     C                   If        PArrCc1(MPNex1) = *Blanks                                  BA6026
     C                   Move      'Y'           Skip1                                        BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C                   Move      'Y'           Skip1                                        BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   If        MPNex2 <> 0                                                BA6026
     C                   If        MPNex2 = 50                                                BA6026
     C                   Eval      PArrCc1(MPNex2) = PPNar2                                   BA6026
     C                   else                                                                 BA6026
     C                   Eval      PArrCc1(MPNex2) = PArrExt22(MPNex2)                        BA6026
     C                   Endif                                                                BA6026
     C                   If        PArrCc1(MPNex2) = *Blanks                                  BA6026
     C                   Move      'Y'           Skip2                                        BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C                   Move      'Y'           Skip2                                        BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   If        MPNex3 <> 0                                                BA6026
     C                   If        MPNex3 = 50                                                BA6026
     C                   Eval      PArrCc1(MPNex3) = PPNar2                                   BA6026
     C                   else                                                                 BA6026
     C                   Eval      PArrCc1(MPNex3) = PArrExt22(MPNex3)                        BA6026
     C                   Endif                                                                BA6026
     C                   If        PArrCc1(MPNex3) = *Blanks                                  BA6026
     C                   Move      'Y'           Skip3                                        BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C                   Move      'Y'           Skip3                                        BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   If        MPNex4 <> 0                                                BA6026
     C                   If        MPNex4 = 50                                                BA6026
     C                   Eval      PArrCc1(MPNex4) = PPNar2                                   BA6026
     C                   else                                                                 BA6026
     C                   Eval      PArrCc1(MPNex4) = PArrExt22(MPNex4)                        BA6026
     C                   Endif                                                                BA6026
     C                   If        PArrCc1(MPNex4) = *Blanks                                  BA6026
     C                   Move      'Y'           Skip4                                        BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C                   Move      'Y'           Skip4                                        BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   If        MPOmit = 'Y'                                               BA6026
     C                             and Skip1 = 'Y'                                            BA6026
     C                             and Skip2 = 'Y'                                            BA6026
     C                             and Skip3 = 'Y'                                            BA6026
     C                             and Skip4 = 'Y'                                            BA6026
     C                   else                                                                 BA6026
      *                                                                                       BA6026
     C                   If        MPSlsh = 'Y'                                               BA6026
     C                             and PArrCC1(MPNex1) <> *Blanks                             BA6026
      *                                                                                       BA6026
     C                   If        MPNex4 <> 0                                                BA6026
     C                   If        MPNEWL <> 'Y'                                              BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) + %TRIM(MPSwcd) +                 BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               '/' +                                                    BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex3):1:MPLen3))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex4):1:MPLen4))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   else                                                                 BA6026
      *                                                                                       BA6026
      ** Obtain number of chars in string                                                     BA6026
     C                   eval      pos = (%SCAN ('NEWLINEID' : WExt046)) - 1                  BA6026
      *                                                                                       BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Z-Add     0             DivRmdr                                      BA6026
     C                   Z-Add     0             RmdgBlk                                      BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
      ** Calculate number of spaces to insert for codeword to start in a New Line             BA6026
     C                   If        Pos > EDNCLN                                               BA6026
     C     Pos           Div       EDNCLN        DivRslt                                      BA6026
     C                   MVR                     DivRmdr                                      BA6026
     C     DivRmdr       IfGt      0                                                          BA6026
     C     EDNCLN        Sub       DivRmdr       RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C     EDNCLN        Sub       Pos           RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
                                                                                              BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) +                                 BA6026
     C                               %Subst(FillBlanks:1:RmdgBlk) +                           BA6026
     C                               %TRIM(MPSwcd) +                                          BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               '/' +                                                    BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex3):1:MPLen3))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex4):1:MPLen4))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C                   If        MPNex3 <> 0                                                BA6026
     C                   If        MPNEWL <> 'Y'                                              BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) + %TRIM(MPSwcd) +                 BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               '/' +                                                    BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex3):1:MPLen3))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   else                                                                 BA6026
      *                                                                                       BA6026
      ** Obtain number of chars in string                                                     BA6026
     C                   eval      pos = (%SCAN ('NEWLINEID' : WExt046)) - 1                  BA6026
      *                                                                                       BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Z-Add     0             DivRmdr                                      BA6026
     C                   Z-Add     0             RmdgBlk                                      BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
      ** Calculate number of spaces to insert for codeword to start in a New Line             BA6026
     C                   If        Pos > EDNCLN                                               BA6026
     C     Pos           Div       EDNCLN        DivRslt                                      BA6026
     C                   MVR                     DivRmdr                                      BA6026
     C     DivRmdr       IfGt      0                                                          BA6026
     C     EDNCLN        Sub       DivRmdr       RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C     EDNCLN        Sub       Pos           RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
                                                                                              BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) +                                 BA6026
     C                               %Subst(FillBlanks:1:RmdgBlk) +                           BA6026
     C                               %TRIM(MPSwcd) +                                          BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               '/' +                                                    BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex3):1:MPLen3))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C                   If        MPNex2 <> 0                                                BA6026
     C                   If        MPNEWL <> 'Y'                                              BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) + %TRIM(MPSwcd) +                 BA6026
     C                               %TRIM(%Subst(PArrCC1(MpNex1):1:MPLen1))+                 BA6026
     C                               '/' +                                                    BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   else                                                                 BA6026
      *                                                                                       BA6026
      ** Obtain number of chars in string                                                     BA6026
     C                   eval      pos = (%SCAN ('NEWLINEID' : WExt046)) - 1                  BA6026
      *                                                                                       BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Z-Add     0             DivRmdr                                      BA6026
     C                   Z-Add     0             RmdgBlk                                      BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
      ** Calculate number of spaces to insert for codeword to start in a New Line             BA6026
     C                   If        Pos > EDNCLN                                               BA6026
     C     Pos           Div       EDNCLN        DivRslt                                      BA6026
     C                   MVR                     DivRmdr                                      BA6026
     C     DivRmdr       IfGt      0                                                          BA6026
     C     EDNCLN        Sub       DivRmdr       RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C     EDNCLN        Sub       Pos           RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
                                                                                              BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) +                                 BA6026
     C                               %Subst(FillBlanks:1:RmdgBlk) +                           BA6026
     C                               %TRIM(MPSwcd) +                                          BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               '/' +                                                    BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C                   If        MPNEWL <> 'Y'                                              BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) + %TRIM(MPSwcd) +                 BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               '/'                                                      BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   else                                                                 BA6026
      *                                                                                       BA6026
      ** Obtain number of chars in string                                                     BA6026
     C                   eval      pos = (%SCAN ('NEWLINEID' : WExt046)) - 1                  BA6026
      *                                                                                       BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Z-Add     0             DivRmdr                                      BA6026
     C                   Z-Add     0             RmdgBlk                                      BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
      ** Calculate number of spaces to insert for codeword to start in a New Line             BA6026
     C                   If        Pos > EDNCLN                                               BA6026
     C     Pos           Div       EDNCLN        DivRslt                                      BA6026
     C                   MVR                     DivRmdr                                      BA6026
     C     DivRmdr       IfGt      0                                                          BA6026
     C     EDNCLN        Sub       DivRmdr       RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C     EDNCLN        Sub       Pos           RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
                                                                                              BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) +                                 BA6026
     C                               %Subst(FillBlanks:1:RmdgBlk) +                           BA6026
     C                               %TRIM(MPSwcd) +                                          BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               '/'                                                      BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   Endif                                                                BA6026
     C                   Endif                                                                BA6026
     C                   Endif                                                                BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   else                                                                 BA6026
      *                                                                                       BA6026
     C                   If        MPNex4 <> 0                                                BA6026
     C                   If        MPNEWL <> 'Y'                                              BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) + %TRIM(MPSwcd) +                 BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex3):1:MPLen3))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex4):1:MPLen4))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   else                                                                 BA6026
      *                                                                                       BA6026
      ** Obtain number of chars in string                                                     BA6026
     C                   eval      pos = (%SCAN ('NEWLINEID' : WExt046)) - 1                  BA6026
      *                                                                                       BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Z-Add     0             DivRmdr                                      BA6026
     C                   Z-Add     0             RmdgBlk                                      BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
      ** Calculate number of spaces to insert for codeword to start in a New Line             BA6026
     C                   If        Pos > EDNCLN                                               BA6026
     C     Pos           Div       EDNCLN        DivRslt                                      BA6026
     C                   MVR                     DivRmdr                                      BA6026
     C     DivRmdr       IfGt      0                                                          BA6026
     C     EDNCLN        Sub       DivRmdr       RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C     EDNCLN        Sub       Pos           RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
                                                                                              BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) +                                 BA6026
     C                               %Subst(FillBlanks:1:RmdgBlk) +                           BA6026
     C                               %TRIM(MPSwcd) +                                          BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex3):1:MPLen3))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex4):1:MPLen4))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C                   If        MPNex3 <> 0                                                BA6026
     C                   If        MPNEWL <> 'Y'                                              BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) + %TRIM(MPSwcd) +                 BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex3):1:MPLen3))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   else                                                                 BA6026
      *                                                                                       BA6026
      ** Obtain number of chars in string                                                     BA6026
     C                   eval      pos = (%SCAN ('NEWLINEID' : WExt046)) - 1                  BA6026
      *                                                                                       BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Z-Add     0             DivRmdr                                      BA6026
     C                   Z-Add     0             RmdgBlk                                      BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
      ** Calculate number of spaces to insert for codeword to start in a New Line             BA6026
     C                   If        Pos > EDNCLN                                               BA6026
     C     Pos           Div       EDNCLN        DivRslt                                      BA6026
     C                   MVR                     DivRmdr                                      BA6026
     C     DivRmdr       IfGt      0                                                          BA6026
     C     EDNCLN        Sub       DivRmdr       RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C     EDNCLN        Sub       Pos           RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
                                                                                              BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) +                                 BA6026
     C                               %Subst(FillBlanks:1:RmdgBlk) +                           BA6026
     C                               %TRIM(MPSwcd) +                                          BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex3):1:MPLen3))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C                   If        MPNex2 <> 0                                                BA6026
     C                   If        MPNEWL <> 'Y'                                              BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) + %TRIM(MPSwcd) +                 BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   else                                                                 BA6026
      *                                                                                       BA6026
      ** Obtain number of chars in string                                                     BA6026
     C                   eval      pos = (%SCAN ('NEWLINEID' : WExt046)) - 1                  BA6026
      *                                                                                       BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Z-Add     0             DivRmdr                                      BA6026
     C                   Z-Add     0             RmdgBlk                                      BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
      ** Calculate number of spaces to insert for codeword to start in a New Line             BA6026
     C                   If        Pos > EDNCLN                                               BA6026
     C     Pos           Div       EDNCLN        DivRslt                                      BA6026
     C                   MVR                     DivRmdr                                      BA6026
     C     DivRmdr       IfGt      0                                                          BA6026
     C     EDNCLN        Sub       DivRmdr       RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C     EDNCLN        Sub       Pos           RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
                                                                                              BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) +                                 BA6026
     C                               %Subst(FillBlanks:1:RmdgBlk) +                           BA6026
     C                               %TRIM(MPSwcd) +                                          BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))+                 BA6026
     C                               ' ' +                                                    BA6026
     C                               %TRIM(%Subst(PArrCc1(MPNex2):1:MPLen2))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C                   If        MPNEWL <> 'Y'                                              BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) + %TRIM(MPSwcd) +                 BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   else                                                                 BA6026
      *                                                                                       BA6026
      ** Obtain number of chars in string                                                     BA6026
     C                   eval      pos = (%SCAN ('NEWLINEID' : WExt046)) - 1                  BA6026
      *                                                                                       BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Z-Add     0             DivRmdr                                      BA6026
     C                   Z-Add     0             RmdgBlk                                      BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
      ** Calculate number of spaces to insert for codeword to start in a New Line             BA6026
     C                   If        Pos > EDNCLN                                               BA6026
     C     Pos           Div       EDNCLN        DivRslt                                      BA6026
     C                   MVR                     DivRmdr                                      BA6026
     C     DivRmdr       IfGt      0                                                          BA6026
     C     EDNCLN        Sub       DivRmdr       RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
     C                   else                                                                 BA6026
     C     EDNCLN        Sub       Pos           RmdgBlk                                      BA6026
     C                   Endif                                                                BA6026
                                                                                              BA6026
     C                   Eval      WExt046 = %TRIM(WExt046) +                                 BA6026
     C                               %Subst(FillBlanks:1:RmdgBlk) +                           BA6026
     C                               %TRIM(MPSwcd) +                                          BA6026
     C                               %TRIM(%Subst(PArrCc1(MpNex1):1:MPLen1))                  BA6026
     C                               + 'NEWLINEID'                                            BA6026
     C                   Endif                                                                BA6026
     C                   Endif                                                                BA6026
     C                   Endif                                                                BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C     K1M940        ReadE     A6M940L0                               80                  BA6026
     C                   Enddo                                                                BA6026
      *                                                                                       BA6026
      ** Remove tag 'NEWLINEID' from string                                                   BA6026
     C                   Move      *Blanks       WWrk046                                      BA6026
     C                   Eval      WWrk046 = %ScanRpl('NEWLINEID':'':WExt046)                 BA6026
     C                   Eval      WExt046 = WWrk046                                          BA6026
      *                                                                                       BA6026
      ** Search and replace invalid SWIFT characters at start of each line                    BA6026
      *                                                                                       BA6026
     C                   Z-Add     1             Cnt               2 0                        BA6026
     C                   If        %subst(WExt046:1:1) = ':'                                  BA6026
     C                             or %subst(WExt046:1:1) = '-'                               BA6026
     C                   Eval      %subst(WExt046:1:1) = '.'                                  BA6026
     C                   Endif                                                                BA6026
     C                   Add       1             Cnt                                          BA6026
     C     1             Add       @Lc           @S                3 0                        BA6026
      *                                                                                       BA6026
     C     Cnt           Dowle     @Ln                                                        BA6026
      *                                                                                       BA6026
     C                   If        %subst(WExt046:@S:1) = ':'                                 BA6026
     C                             or %subst(WExt046:@S:1) = '-'                              BA6026
     C                   Eval      %subst(WExt046:@S:1) = '.'                                 BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Enddo                                                                BA6026
      *                                                                                       BA6026
      ** Populate PFormL* output parameters                                                   BA6026
      *                                                                                       BA6026
     C                   Z-Add     1             Cnt                                          BA6026
     C                   Z-Add     1             @S                                           BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   Eval      PFormL1 = %subst(WExt046:@S:@Lc)                           BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL2 = %subst(WExt046:@S:@Lc)                           BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL3 = %subst(WExt046:@S:@Lc)                           BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL4 = %subst(WExt046:@S:@Lc)                           BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL5 = %subst(WExt046:@S:@Lc)                           BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL6 = %subst(WExt046:@S:@Lc)                           BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL7 = %subst(WExt046:@S:@Lc)                           BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL8 = %subst(WExt046:@S:@Lc)                           BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL9 = %subst(WExt046:@S:@Lc)                           BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL10 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL11 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL12 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL13 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL14 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL15 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL16 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL17 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL18 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL19 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL20 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL21 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
     C     Cnt           Ifle      @Ln                                                        BA6026
     C     Cnt           andle     22                                                         BA6026
     C                   EVAL      PFormL22 = %subst(WExt046:@S:@Lc)                          BA6026
     C                   Add       1             Cnt                                          BA6026
     C                   Add       @Lc           @S                                           BA6026
     C                   Endif                                                                BA6026
      *                                                                                       BA6026
     C                   ENDSR                                                                BA6026
      *****************************************************************                       BA6026
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrFmtNew - Format Field 86 in Structured 6*65                *                     MD062339
      *                                                               *                     MD062339
      *  Called by : Main                                             *                     MD062339
      *                                                               *                     MD062339
      *  Calls : None                                                 *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrFmtNew      BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** Inialise workfields                                                                MD062339
     C                   Eval      WKBENM = *Blanks                                         MD062339
     C                   Eval      WKORDP = *Blanks                                         MD062339
     C                   Eval      WKIBAN = *Blanks                                         MD062339
     C                   Eval      WKBENB = *Blanks                                         MD062339
     C                   Eval      WKORDB = *Blanks                                         MD062339
     C                   Eval      WKREMI = *Blanks                                         MD062339
     C                   Eval      WKEREF = *Blanks                                         MD062339
     C                   Eval      WKCHGS = *Blanks                                         MD062339
     C                   Eval      WKOCMT = *Blanks                                         MD062339
     C                   Eval      WKEXCH = *Blanks                                         MD062339
     C                   Eval      WKTRTP = *Blanks                                         MD062339
     C                   Eval      WKRTRN = *Blanks                                         MD062339
      *                                                                                     MD062339
      ** Look up in arrays of Transaction Types to determine                                MD062339
      ** formatting type                                                                    MD062339
      *                                                                                     MD062339
     C                   Eval      FMTMode = *blanks                                        MD062339
     C     PTranTp       Lookup    TRFUnstInc                             99                MD062339
      *                                                                                     MD062339
     C                   If        *IN99 = *ON                                              MD062339
     C                   Eval      FMTMode = 'TRFUI'                                        MD062339
     C                   Else                                                               MD062339
     C     PTranTp       Lookup    TRFUnstOut                             99                MD062339
      *                                                                                     MD062339
     C                   If        *IN99 = *ON                                              MD062339
     C                   Eval      FMTMode = 'TRFUO'                                        MD062339
     C                   Else                                                               MD062339
     C     PTranTp       Lookup    TRFStrucInc                            99                MD062339
      *                                                                                     MD062339
     C                   If        *IN99 = *ON                                              MD062339
     C                   Eval      FMTMode = 'TRFSI'                                        MD062339
     C                   Else                                                               MD062339
     C     PTranTp       Lookup    TRFStrucOut                            99                MD062339
      *                                                                                     MD062339
     C                   If        *IN99 = *ON                                              MD062339
     C                   Eval      FMTMode = 'TRFSO'                                        MD062339
     C                   Else                                                               MD062339
     C     PTranTp       Lookup    RTIInc                                 99                MD062339
      *                                                                                     MD062339
     C                   If        *IN99 = *ON                                              MD062339
     C                   Eval      FMTMode = 'RTII'                                         MD062339
     C                   Else                                                               MD062339
     C     PTranTp       Lookup    RTIOut                                 99                MD062339
      *                                                                                     MD062339
     C                   If        *IN99 = *ON                                              MD062339
     C                   Eval      FMTMode = 'RTIO'                                         MD062339
     C                   Else                                                               MD062339
     C     PTranTp       Lookup    CHGIncOut                              99                MD062339
      *                                                                                     MD062339
     C                   If        *IN99 = *ON                                              MD062339
     C                   Eval      FMTMode = 'CHGIO'                                        MD062339
     C                   Else                                                               MD062339
     C                   Eval      FMTMode = 'UNSTR'                                        MD062339
      *                                                                                     MD062339
     C                   Endif                                                              MD062339
     C                   Endif                                                              MD062339
     C                   Endif                                                              MD062339
     C                   Endif                                                              MD062339
     C                   Endif                                                              MD062339
     C                   Endif                                                              MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
      ** Format Field 86 based on Transaction Type of this posting.                         MD062339
     C                   SELECT                                                             MD062339
      ** --- TRF Unstructured REM.INFO (Incoming) ---                                       MD062339
     C                   WHEN      FMTMode = 'TRFUI'                                        MD062339
     C                   EXSR      SrORDP                                                   MD062339
     C                   EXSR      SrIBAN                                                   MD062339
     C                   EXSR      SrORDB                                                   MD062339
     C                   EXSR      SrREMI                                                   MD062339
     C                   EXSR      SrEREF                                                   MD062339
     C                   EXSR      SrCHGS                                                   MD062339
     C                   EXSR      SrOCMT                                                   MD062339
     C                   EXSR      SrEXCH                                                   MD062339
     C                   EXSR      SrTRTP                                                   MD062339
     C                   EXSR      SrConcTags                                               MD062339
      *                                                                                     MD062339
      ** --- TRF Unstructured REM.INFO (Outgoing) ---                                       MD062339
     C                   WHEN      FMTMode = 'TRFUO'                                        MD062339
     C                   EXSR      SrBENM                                                   MD062339
     C                   EXSR      SrIBAN                                                   MD062339
     C                   EXSR      SrBENB                                                   MD062339
     C                   EXSR      SrREMI                                                   MD062339
     C                   EXSR      SrEREF                                                   MD062339
     C                   EXSR      SrCHGS                                                   MD062339
     C                   EXSR      SrOCMT                                                   MD062339
     C                   EXSR      SrEXCH                                                   MD062339
     C                   EXSR      SrTRTP                                                   MD062339
     C                   EXSR      SrConcTags                                               MD062339
      *                                                                                     MD062339
      ** --- TRF Structured REM.INFO (Incoming) ---                                         MD062339
     C                   WHEN      FMTMode = 'TRFSI'                                        MD062339
     C                   EXSR      SrORDP                                                   MD062339
     C                   EXSR      SrIBAN                                                   MD062339
     C                   EXSR      SrORDB                                                   MD062339
     C                   EXSR      SrREMI                                                   MD062339
     C                   EXSR      SrEREF                                                   MD062339
     C                   EXSR      SrTRTP                                                   MD062339
     C                   EXSR      SrConcTags                                               MD062339
      *                                                                                     MD062339
      ** --- TRF Structured REM.INFO (Outgoing) ---                                         MD062339
     C                   WHEN      FMTMode = 'TRFSO'                                        MD062339
     C                   EXSR      SrBENM                                                   MD062339
     C                   EXSR      SrIBAN                                                   MD062339
     C                   EXSR      SrBENB                                                   MD062339
     C                   EXSR      SrREMI                                                   MD062339
     C                   EXSR      SrEREF                                                   MD062339
     C                   EXSR      SrTRTP                                                   MD062339
     C                   EXSR      SrConcTags                                               MD062339
      *                                                                                     MD062339
      ** --- RTI (Incoming) ---                                                             MD062339
     C                   WHEN      FMTMode = 'RTII'                                         MD062339
     C                   EXSR      SrRTRN                                                   MD062339
     C                   EXSR      SrBENM                                                   MD062339
     C                   EXSR      SrIBAN                                                   MD062339
     C                   EXSR      SrBENB                                                   MD062339
     C                   EXSR      SrREMI                                                   MD062339
     C                   EXSR      SrEREF                                                   MD062339
     C                   EXSR      SrTRTP                                                   MD062339
     C                   EXSR      SrConcTags                                               MD062339
      *                                                                                     MD062339
      ** --- RTI (Outgoing) ---                                                             MD062339
     C                   WHEN      FMTMode = 'RTIO'                                         MD062339
     C                   EXSR      SrRTRN                                                   MD062339
     C                   EXSR      SrORDP                                                   MD062339
     C                   EXSR      SrIBAN                                                   MD062339
     C                   EXSR      SrORDB                                                   MD062339
     C                   EXSR      SrREMI                                                   MD062339
     C                   EXSR      SrEREF                                                   MD062339
     C                   EXSR      SrTRTP                                                   MD062339
     C                   EXSR      SrConcTags                                               MD062339
      *                                                                                     MD062339
      ** --- CHG (Incoming and Outgoing) ---                                                MD062339
     C                   WHEN      FMTMode = 'CHGIO'                                        MD062339
     C                   EXSR      SrCHGS                                                   MD062339
     C                   EXSR      SrTRTP                                                   MD062339
     C                   EXSR      SrConcTags                                               MD062339
      *                                                                                     MD062339
      ** --- Format as current (unstructured) ---                                           MD062339
     C                   OTHER                                                              MD062339
     C                   EXSR      SrNarr                                                   MD062339
     C                   EXSR      SRFormat                                                 MD062339
     C                   ENDSL                                                              MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrORDP - Format /ORDP/ tag                                   *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrORDP        BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** ORDP (Ordering party/sender for Incoming Payment)                                  MD062339
      *                                                                                     MD062339
      ** When BA6026 is off, extract Extended Narrative Field2                              MD062339
                                                                                            MD062339
      *                                                                                     MD062339
     C                   If        BA6026 = 'N' Or                                          MD062339
     C                             (BA6026='Y' And FMTMode = 'RTIO')                        MD062339
      *                                                                                     MD062339
     C                   Eval      WKORDP = '/ORDP/' + %TRIM(PArrExt22(1))                  MD062339
     C                             + ' ' + %TRIM(PArrExt22(2))                              MD062339
     C                   Else                                                               MD062339
      *                                                                                     MD062339
      ** limit format to Incoming payments                                                  MD062339
      *                                                                                     MD062339
     C                   If        FMTMode = 'TRFUI' OR                                     MD062339
     C                             FMTMode = 'TRFSI'                                        MD062339
     C                   Eval      WKORDP = '/ORDP/' + %TRIM(PArrExt22(1))                  MD062339
     C                   Endif                                                              MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrBENM - Format /BENM/ tag                                   *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrBENM        BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** BENM (Beneficiary for Outgoing Payment)                                            MD062339
     C                   Eval      WKBENM = '/BENM/' + %TRIM(PArrExt22(1))                  MD062339
     C                             + ' ' + %TRIM(PArrExt22(2))                              MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrORDB - Format /ORDB/ tag                                   *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrORDB        BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** ORDB (BIC of Ordering Bank/Senders Bank in Incoming Payment)                       MD062339
     C                   Eval      WKORDB = '/ORDB/' + %TRIM(PArrExt22(19))                 MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrBENB - Format /BENB/ tag                                   *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrBENB        BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** BENB (BIC of Beneficiary bank in Outgoing Payment)                                 MD062339
     C                   Eval      WKBENB = '/BENB/' + %TRIM(PArrExt22(19))                 MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrIBAN - Format /IBAN/ tag                                   *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrIBAN        BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** IBAN (IBAN of Ordering Party or Beneficiary)                                       MD062339
     C                   Eval      WKIBAN = '/IBAN/' + %TRIM(PArrExt22(5))                  MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrREMI - Format /REMI/ or /REMI/SCOR/ tag                    *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrREMI        BEGSR                                                              MD062339
      *                                                                                     MD062339
     C                   If        FMTMode = 'TRFUI' or FMTMode = 'TRFUO'                   MD062339
     C                             or FMTMode = 'RTII' or FMTMode = 'RTIO'                  MD062339
      ** REMI (Remittance Information [unstructured])                                       MD062339
     C                   Eval      WKREMI = '/REMI/' + %TRIM(PArrExt22(6))                  MD062339
     C                             + ' ' + %TRIM(PArrExt22(7))                              MD062339
     C                             + ' ' + %TRIM(PArrExt22(8))                              MD062339
     C                             + ' ' + %TRIM(PArrExt22(9))                              MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   If        FMTMode = 'TRFSI' or FMTMode = 'TRFSO'                   MD062339
      ** REMI/SCOR (Remittance Information [structured])                                    MD062339
     C                   Eval      WKREMI = '/REMI/SCOR/' + %TRIM(PArrExt22(6))             MD062339
     C                             + '/' + %TRIM(PArrExt22(7))                              MD062339
     C                             + ' ' + %TRIM(PArrExt22(8))                              MD062339
     C                             + ' ' + %TRIM(PArrExt22(9))                              MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrEREF - Format /EREF/ tag                                   *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrEREF        BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** EREF (End to End Reference)                                                        MD062339
     C                   Eval      WKEREF = '/EREF/' + %TRIM(PArrExt22(12))                 MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrCHGS - Format /CHGS/ tag                                   *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrCHGS        BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** CHGS (Charges related to the transaction)                                          MD062339
      *                                                                                     MD062339
     C                   SELECT                                                             MD062339
     C                   When      FMTMode <> 'CHGIO'                                       MD062339
     C                   If        PArrExt22(13) <> *BLANKS                                 MD062339
     C                   Eval      WKCHGS = '/CHGS/' + %TRIM(PArrExt22(13))                 MD062339
     C                             + '/'                                                    MD062339
     C                   Else                                                               MD062339
     C                   Eval      WKCHGS = *BLANKS                                         MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   When      FMTMode = 'CHGIO'                                        MD062339
     C                   If        PPNarr <> *BLANKS                                        MD062339
     C                   Eval      WKCHGS = '/CHGS/' + %TRIM(PPNarr)                        MD062339
     C                   Else                                                               MD062339
     C                   Eval      WKCHGS = *BLANKS                                         MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   ENDSL                                                              MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrOCMT - Format /OCMT/ tag                                   *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrOCMT        BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** OCMT (Original Amount)                                                             MD062339
     C                   If        PArrExt22(15) <> *BLANKS                                 MD062339
     C                   Eval      WKOCMT = '/OCMT/' + %TRIM(PArrExt22(15))                 MD062339
     C                             + '/'                                                    MD062339
     C                   Else                                                               MD062339
     C                   Eval      WKOCMT = *BLANKS                                         MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrEXCH - Format /EXCH/ tag                                   *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrEXCH        BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** EXCH (Exchange Rate)                                                               MD062339
     C                   If        PArrExt22(14) <> *BLANKS                                 MD062339
     C                   Eval      WKEXCH = '/EXCH/' + %TRIM(PArrExt22(14))                 MD062339
     C                             + '/'                                                    MD062339
     C                   Else                                                               MD062339
     C                   Eval      WKEXCH = *BLANKS                                         MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrRTRN - Format /RTRN/ tag                                   *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrRTRN        BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** RTRN (Return Reason)                                                               MD062339
     C                   Eval      WKRTRN = '/RTRN/' + %TRIM(PArrExt22(21))                 MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrTRTP - Format /TRTP/ tag                                   *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrTRTP        BEGSR                                                              MD062339
      *                                                                                     MD062339
      ** TRTP (Transaction Type Description)                                                MD062339
     C                   Eval      WKTRTP = '/TRTP/' + %TRIM(PArrExt22(20))                 MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                MD062339
      *****************************************************************                     MD062339
      *                                                               *                     MD062339
      *  SrConcTags - Concatenate Field 86 Tags                       *                     MD062339
      *  Called by : SrFmtNew                                         *                     MD062339
      *                                                               *                     MD062339
      *****************************************************************                     MD062339
     C     SrConcTags    BEGSR                                                              MD062339
      *                                                                                     MD062339
     C                   Eval      WENarrNew = *Blanks                                      MD062339
     C                   Eval      WENarrNew2= *Blanks                                      MD062339
     C                   Eval      WAdded = *Blanks                                         MD062339
      *                                                                                     MD062339
     C                   SELECT                                                             MD062339
      ** --- TRF Unstructured REM.INFO (Incoming) ---                                       MD062339
     C                   WHEN      FMTMode = 'TRFUI'                                        MD062339
     C                   Eval      WENarrNew = %Trim(WKORDP) + %Trim(WKIBAN) +              MD062339
     C                                         %Trim(WKORDB) + %Trim(WKREMI) +              MD062339
     C                                         %Trim(WKEREF) + %Trim(WKTRTP) +              MD062339
     C                                         %Trim(WKCHGS) + %Trim(WKOCMT) +              MD062339
     C                                         %Trim(WKEXCH)                                MD062339
      *                                                                                     MD062339
      ** --- TRF Unstructured REM.INFO (Outgoing) ---                                       MD062339
     C                   WHEN      FMTMode = 'TRFUO'                                        MD062339
     C                   Eval      WENarrNew = %Trim(WKBENM) + %Trim(WKIBAN) +              MD062339
     C                                         %Trim(WKBENB) + %Trim(WKREMI) +              MD062339
     C                                         %Trim(WKEREF) + %Trim(WKTRTP) +              MD062339
     C                                         %Trim(WKCHGS) + %Trim(WKOCMT) +              MD062339
     C                                         %Trim(WKEXCH)                                MD062339
      *                                                                                     MD062339
      ** --- TRF Structured REM.INFO (Incoming) ---                                         MD062339
     C                   WHEN      FMTMode = 'TRFSI'                                        MD062339
     C                   Eval      WENarrNew = %Trim(WKORDP) + %Trim(WKIBAN) +              MD062339
     C                                         %Trim(WKORDB) + %Trim(WKREMI) +              MD062339
     C                                         %Trim(WKEREF) + %Trim(WKTRTP)                MD062339
      *                                                                                     MD062339
      ** --- TRF Structured REM.INFO (Outgoing) ---                                         MD062339
     C                   WHEN      FMTMode = 'TRFSO'                                        MD062339
     C                   Eval      WENarrNew = %Trim(WKBENM) + %Trim(WKIBAN) +              MD062339
     C                                         %Trim(WKBENB) + %Trim(WKREMI) +              MD062339
     C                                         %Trim(WKEREF) + %Trim(WKTRTP)                MD062339
      *                                                                                     MD062339
      ** --- RTI (Incoming) ---                                                             MD062339
     C                   WHEN      FMTMode = 'RTII'                                         MD062339
     C                   Eval      WENarrNew = %Trim(WKRTRN) + %Trim(WKBENM) +              MD062339
     C                                         %Trim(WKIBAN) + %Trim(WKBENB) +              MD062339
     C                                         %Trim(WKREMI) + %Trim(WKEREF) +              MD062339
     C                                         %Trim(WKTRTP)                                MD062339
      *                                                                                     MD062339
      ** --- RTI (Outgoing) ---                                                             MD062339
     C                   WHEN      FMTMode = 'RTIO'                                         MD062339
     C                   Eval      WENarrNew = %Trim(WKRTRN) + %Trim(WKORDP) +              MD062339
     C                                         %Trim(WKIBAN) + %Trim(WKORDB) +              MD062339
     C                                         %Trim(WKREMI) + %Trim(WKEREF) +              MD062339
     C                                         %Trim(WKTRTP)                                MD062339
      *                                                                                     MD062339
      ** --- CHG (Incoming and Outgoing) ---                                                MD062339
     C                   WHEN      FMTMode = 'CHGIO'                                        MD062339
     C                   Eval      WENarrNew = %Trim(WKCHGS) + %Trim(WKTRTP)                MD062339
      *                                                                                     MD062339
     C                   ENDSL                                                              MD062339
      *                                                                                     MD062339
      ** Check for double slash ('//') or colon (':') or hyphen ('-') at                    MD062339
      ** the beginning of each 6*65 line then pad or replace by period ('.')                MD062339
      ** if found.                                                                          MD062339
     C                   Eval      ChkFound = 'N'                                           MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL1 = %subst(WENarrNew:1:65)                         MD062339
     C                   If        %subst(CheckL1:1:1) = ':'                                MD062339
     C                             or %subst(CheckL1:1:1) = '-'                             MD062339
     C                   Eval      %subst(CheckL1:1:1) = '.'                                MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL2 = %subst(WENarrNew:66:65)                        MD062339
     C                   If        %subst(CheckL2:1:1) = ':'                                MD062339
     C                             or %subst(CheckL2:1:1) = '-'                             MD062339
     C                   Eval      %subst(CheckL2:1:1) = '.'                                MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL3 = %subst(WENarrNew:131:65)                       MD062339
     C                   If        %subst(CheckL3:1:1) = ':'                                MD062339
     C                             or %subst(CheckL3:1:1) = '-'                             MD062339
     C                   Eval      %subst(CheckL3:1:1) = '.'                                MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL4 = %subst(WENarrNew:196:65)                       MD062339
     C                   If        %subst(CheckL4:1:1) = ':'                                MD062339
     C                             or %subst(CheckL4:1:1) = '-'                             MD062339
     C                   Eval      %subst(CheckL4:1:1) = '.'                                MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL5 = %subst(WENarrNew:261:65)                       MD062339
     C                   If        %subst(CheckL5:1:1) = ':'                                MD062339
     C                             or %subst(CheckL5:1:1) = '-'                             MD062339
     C                   Eval      %subst(CheckL5:1:1) = '.'                                MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL6 = %subst(WENarrNew:326:65)                       MD062339
     C                   If        %subst(CheckL6:1:1) = ':'                                MD062339
     C                             or %subst(CheckL6:1:1) = '-'                             MD062339
     C                   Eval      %subst(CheckL6:1:1) = '.'                                MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL7 = %subst(WENarrNew:391:65)                       MD062339
     C                   If        %subst(CheckL7:1:1) = ':'                                MD062339
     C                             or %subst(CheckL7:1:1) = '-'                             MD062339
     C                   Eval      %subst(CheckL7:1:1) = '.'                                MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL8 = %subst(WENarrNew:456:65)                       MD062339
     C                   If        %subst(CheckL8:1:1) = ':'                                MD062339
     C                             or %subst(CheckL8:1:1) = '-'                             MD062339
     C                   Eval      %subst(CheckL8:1:1) = '.'                                MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL9 = %subst(WENarrNew:521:65)                       MD062339
     C                   If        %subst(CheckL9:1:1) = ':'                                MD062339
     C                             or %subst(CheckL9:1:1) = '-'                             MD062339
     C                   Eval      %subst(CheckL9:1:1) = '.'                                MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL10 = %subst(WENarrNew:586:65)                      MD062339
     C                   If        %subst(CheckL10:1:1) = ':'                               MD062339
     C                             or %subst(CheckL10:1:1) = '-'                            MD062339
     C                   Eval      %subst(CheckL10:1:1) = '.'                               MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL11 = %subst(WENarrNew:651:65)                      MD062339
     C                   If        %subst(CheckL11:1:1) = ':'                               MD062339
     C                             or %subst(CheckL11:1:1) = '-'                            MD062339
     C                   Eval      %subst(CheckL11:1:1) = '.'                               MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
     C                   EVAL      CheckL12 = %subst(WENarrNew:716:55)                      MD062339
     C                   If        %subst(CheckL12:1:1) = ':'                               MD062339
     C                             or %subst(CheckL12:1:1) = '-'                            MD062339
     C                   Eval      %subst(CheckL12:1:1) = '.'                               MD062339
     C                   Eval      ChkFound = 'Y'                                           MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
      ** If replacement occurred, rebuild output array                                      MD062339
     C                   If        ChkFound = 'Y'                                           MD062339
     C                   Eval      WENarrNew = *Blanks                                      MD062339
     C                   Eval      WENarrNew = %trim(CheckL1) +                             MD062339
     C                                         %trim(CheckL2) +                             MD062339
     C                                         %trim(CheckL3) +                             MD062339
     C                                         %trim(CheckL4) +                             MD062339
     C                                         %trim(CheckL5) +                             MD062339
     C                                         %trim(CheckL6) +                             MD062339
     C                                         %trim(CheckL7) +                             MD062339
     C                                         %trim(CheckL8) +                             MD062339
     C                                         %trim(CheckL9) +                             MD062339
     C                                         %trim(CheckL10) +                            MD062339
     C                                         %trim(CheckL11) +                            MD062339
     C                                         %trim(CheckL12)                              MD062339
     C                   Endif                                                              MD062339
      *                                                                                     MD062339
      ** Output in 6*65 format (tags concatenated)                                          MD062339
     C                   EVAL      PFormL1 = %subst(WENarrNew:1:65)                         MD062339
     C                   EVAL      PFormL2 = %subst(WENarrNew:66:65)                        MD062339
     C                   EVAL      PFormL3 = %subst(WENarrNew:131:65)                       MD062339
     C                   EVAL      PFormL4 = %subst(WENarrNew:196:65)                       MD062339
     C                   EVAL      PFormL5 = %subst(WENarrNew:261:65)                       MD062339
     C                   EVAL      PFormL6 = %subst(WENarrNew:326:65)                       MD062339
      *                                                                                     MD062339
     C                   ENDSR                                                              MD062339
      *****************************************************************                     MD062339
      /EJECT                                                                                  BA6026
      *****************************************************************                       BA6026
      *                                                               *                       BA6026
      *  SrLoadTType - Load retrieved Tx Types system values into     *                       BA6026
      *                arrays.                                        *                       BA6026
      *  Called by : *INZSR                                           *                       BA6026
      *                                                               *                       BA6026
      *****************************************************************                       BA6026
     C     SrLoadTType   BEGSR                                                                BA6026
      *                                                                                       BA6026
     C                   Eval      Len = 5                                                    BA6026
      *                                                                                       BA6026
      ** Process 'TTyp_TRF_UnstREMIInc'                                                       BA6026
     C                   Eval      TRFUnstInc = *blanks                                       BA6026
     C                   Eval      Str = 1                                                    BA6026
     C                   Eval      Z = 1                                                      BA6026
     C     Z             DowLE     40                                                         BA6026
     C                   If        %Subst(SVVL01:Str:Len) = *blanks                           BA6026
     C                   Leave                                                                BA6026
     C                   Else                                                                 BA6026
     C                   Eval      TRFUnstInc(Z) = %Subst(SVVL01:Str:Len)                     BA6026
     C                   Eval      Str = Str + 5                                              BA6026
     C                   Eval      Z = Z + 1                                                  BA6026
     C                   Endif                                                                BA6026
     C                   Enddo                                                                BA6026
      *                                                                                     MD062339
      ** Process 'TTyp_TRF_UnstREMIOut'                                                     MD062339
     C                   Eval      TRFUnstOut = *blanks                                     MD062339
     C                   Eval      Str = 1                                                  MD062339
     C                   Eval      Z = 1                                                    MD062339
     C     Z             DowLE     40                                                       MD062339
     C                   If        %Subst(SVVL02:Str:Len) = *blanks                         MD062339
     C                   Leave                                                              MD062339
     C                   Else                                                               MD062339
     C                   Eval      TRFUnstOut(Z) = %Subst(SVVL02:Str:Len)                   MD062339
     C                   Eval      Str = Str + 5                                            MD062339
     C                   Eval      Z = Z + 1                                                MD062339
     C                   Endif                                                              MD062339
     C                   Enddo                                                              MD062339
      *                                                                                       BA6026
      ** Process 'TTyp_TRF_StrREMIInc'                                                        BA6026
     C                   Eval      TRFStrucInc = *blanks                                      BA6026
     C                   Eval      Str = 1                                                    BA6026
     C                   Eval      Z = 1                                                      BA6026
     C     Z             DowLE     40                                                         BA6026
     C*****              If        %Subst(SVVL02:Str:Len) = *blanks                   BA6026MD062339
     C                   If        %Subst(SVVL03:Str:Len) = *blanks                         MD062339
     C                   Leave                                                                BA6026
     C                   Else                                                                 BA6026
     C*****              Eval      TRFStrucInc(Z) = %Subst(SVVL02:Str:Len)            BA6026MD062339
     C                   Eval      TRFStrucInc(Z) = %Subst(SVVL03:Str:Len)                  MD062339
     C                   Eval      Str = Str + 5                                              BA6026
     C                   Eval      Z = Z + 1                                                  BA6026
     C                   Endif                                                                BA6026
     C                   Enddo                                                                BA6026
      *                                                                                     MD062339
      ** Process 'TTyp_TRF_StrREMIOut'                                                      MD062339
     C                   Eval      TRFStrucOut = *blanks                                    MD062339
     C                   Eval      Str = 1                                                  MD062339
     C                   Eval      Z = 1                                                    MD062339
     C     Z             DowLE     40                                                       MD062339
     C                   If        %Subst(SVVL04:Str:Len) = *blanks                         MD062339
     C                   Leave                                                              MD062339
     C                   Else                                                               MD062339
     C                   Eval      TRFStrucOut(Z) = %Subst(SVVL04:Str:Len)                  MD062339
     C                   Eval      Str = Str + 5                                            MD062339
     C                   Eval      Z = Z + 1                                                MD062339
     C                   Endif                                                              MD062339
     C                   Enddo                                                              MD062339
      *                                                                                     MD062339
      ** Process 'TTyp_RTI_Incoming'                                                        MD062339
     C                   Eval      RTIInc = *blanks                                         MD062339
     C                   Eval      Str = 1                                                  MD062339
     C                   Eval      Z = 1                                                    MD062339
     C     Z             DowLE     40                                                       MD062339
     C                   If        %Subst(SVVL05:Str:Len) = *blanks                         MD062339
     C                   Leave                                                              MD062339
     C                   Else                                                               MD062339
     C                   Eval      RTIInc(Z) = %Subst(SVVL05:Str:Len)                       MD062339
     C                   Eval      Str = Str + 5                                            MD062339
     C                   Eval      Z = Z + 1                                                MD062339
     C                   Endif                                                              MD062339
     C                   Enddo                                                              MD062339
      *                                                                                     MD062339
      ** Process 'TTyp_RTI_Outgoing'                                                        MD062339
     C                   Eval      RTIOut = *blanks                                         MD062339
     C                   Eval      Str = 1                                                  MD062339
     C                   Eval      Z = 1                                                    MD062339
     C     Z             DowLE     40                                                       MD062339
     C                   If        %Subst(SVVL06:Str:Len) = *blanks                         MD062339
     C                   Leave                                                              MD062339
     C                   Else                                                               MD062339
     C                   Eval      RTIOut(Z) = %Subst(SVVL06:Str:Len)                       MD062339
     C                   Eval      Str = Str + 5                                            MD062339
     C                   Eval      Z = Z + 1                                                MD062339
     C                   Endif                                                              MD062339
     C                   Enddo                                                              MD062339
      *                                                                                     MD062339
      ** Process 'TTyp_CHG_Inc_Out'                                                         MD062339
     C                   Eval      CHGIncOut = *blanks                                      MD062339
     C                   Eval      Str = 1                                                  MD062339
     C                   Eval      Z = 1                                                    MD062339
     C     Z             DowLE     40                                                       MD062339
     C                   If        %Subst(SVVL07:Str:Len) = *blanks                         MD062339
     C                   Leave                                                              MD062339
     C                   Else                                                               MD062339
     C                   Eval      CHGIncOut(Z) = %Subst(SVVL07:Str:Len)                    MD062339
     C                   Eval      Str = Str + 5                                            MD062339
     C                   Eval      Z = Z + 1                                                MD062339
     C                   Endif                                                              MD062339
     C                   Enddo                                                              MD062339
      *                                                                                       BA6026
      ** Process 'A6Fld86AddChg'                                                              BA6026
     C*****              Eval      A6Fld86AddChg = SVVL03                             BA6026MD062339
     C                   Eval      A6Fld86AddChg = SVVL08                                   MD062339
     C                   If        A6Fld86AddChg <> 'Y'                                       BA6026
     C                             And A6Fld86AddChg <> 'N'                                   BA6026
     C                   Eval      A6Fld86AddChg = 'N'                                        BA6026
     C                   EndIf                                                                BA6026
      *                                                                                       BA6026
     C                   ENDSR                                                                BA6026
      *****************************************************************                       BA6026
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation Subroutine                           *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Begin Parameter List
      *
     C     *ENTRY        PLIST
      *
      ** Return Code
      *
     C                   PARM                    PRtcd
      *
      ** Option
      *
     C                   PARM                    POptn
      *
      ** Network
      *
     C                   PARM                    PNwrk
      *
      ** Message Type
      *
     C                   PARM                    PMsgTyp
      *
      ** Branch code
      *
     C                   PARM                    PBrca
      *
      ** Customer Number
      *
     C                   PARM                    PCNum
      *
      ** Currency
      *
     C                   PARM                    PCcy
      *
      ** Account Number
      *
     C                   PARM                    PAccd
      *
      ** Account sequence
      *
     C                   PARM                    PAcsq
      *
      ** Debit/Credit Indicator
      *
     C                   PARM                    PDCInd
      *
      ** Transaction Type
      *
     C                   PARM                    PTranTp
      *                                                                                       BA6026
      ** Posting Narrative                                                                    BA6026
      *                                                                                       BA6026
     C                   PARM                    PPNarr                                       BA6026
      *                                                                                       BA6026
      ** Network Account Type                                                                 BA6026
      *                                                                                       BA6026
     C                   PARM                    PNaty                                        BA6026
      *                                                                                       BA6026
      ** Destination                                                                          BA6026
      *                                                                                       BA6026
     C                   PARM                    PDstn                                        BA6026
      *
      ** Extended Narratives of length 22 * 35
      *
     C                   PARM                    PArrExt22
      *
      ** Narratives format 20 * 70
      *
     C                   PARM                    PFormL1
     C                   PARM                    PFormL2
     C                   PARM                    PFormL3
     C                   PARM                    PFormL4
     C                   PARM                    PFormL5
     C                   PARM                    PFormL6
     C                   PARM                    PFormL7
     C                   PARM                    PFormL8
     C                   PARM                    PFormL9
     C                   PARM                    PFormL10
     C                   PARM                    PFormL11
     C                   PARM                    PFormL12
     C                   PARM                    PFormL13
     C                   PARM                    PFormL14
     C                   PARM                    PFormL15
     C                   PARM                    PFormL16
     C                   PARM                    PFormL17
     C                   PARM                    PFormL18
     C                   PARM                    PFormL19
     C                   PARM                    PFormL20
     C                   PARM                    PFormL21
     C                   PARM                    PFormL22
      *
     C                   PARM                    Idx
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    PPNar2           30                         BA6026
      *
      ** End Parameter List
      *
      ** KList for file GLNW94L11
      *
     C     KAcct         KLIST
     C                   KFLD                    KBrca
     C                   KFLD                    KCNum
     C                   KFLD                    KCcy
     C                   KFLD                    KAccd
     C                   KFLD                    KAcsq
      *
      ** KList for file GLNW94L8                                                              BA6026
      *                                                                                       BA6026
     C     KAcct2        KLIST                                                                BA6026
     C                   KFLD                    KNetw2                                       BA6026
     C                   KFLD                    KBrca2                                       BA6026
     C                   KFLD                    KCnum2                                       BA6026
     C                   KFLD                    KCcy2                                        BA6026
     C                   KFLD                    KAccd2                                       BA6026
     C                   KFLD                    KAcsq2                                       BA6026
     C                   KFLD                    KNaty2                                       BA6026
     C                   KFLD                    KDstn2                                       BA6026
      *                                                                                       BA6026
      ** Initialize arrays
      *
     C                   EVAL      Arr22 = *BLANKS
     C                   EVAL      PRtcd = *BLANKS
      *                                                                                       BA6020
     C                   MOVE      'N'           BA6020                                       BA6020
     C                   CALL      'AOSARDR0'                                                 BA6020
     C                   PARM      *BLANK        ##RTCD            7                          BA6020
     C                   PARM      '*FIRST  '    ##OPTN            7                          BA6020
     C                   PARM      'BA6020'      ##SARD            6                          BA6020
     C     SCSARD        PARM      *BLANKS       DSFDY                                        BA6020
      *                                                                                       BA6020
     C     ##RTCD        IFEQ      *BLANK                                                     BA6020
     C                   MOVE      'Y'           BA6020            1                          BA6020
     C                   ENDIF                                                                BA6020
      *                                                                                       BA6026
      ** Check if feature BA6026 is installed.                                                BA6026
      *                                                                                       BA6026
     C                   CALL      'AOSARDR0'                                                 BA6026
     C                   PARM      *BLANKS       PRtcdAO                                      BA6026
     C                   PARM      '*VERIFY'     POptnAO                                      BA6026
     C                   PARM      'BA6026 '     PSardAO                                      BA6026
      *                                                                                       BA6026
     C                   IF        PRtcdAO = *BLANKS                                          BA6026
     C                   EVAL      BA6026 = 'Y'                                               BA6026
      *                                                                                       BA6026
      ** Retrieve Transaction Type system values                                              BA6026
     C                   CALL      'AOSVALR0'                                                 BA6026
     C                   PARM      *BLANKS       PRtCdIn                                      BA6026
     C                   PARM      SVALK1        SVOP01                                       BA6026
     C                   PARM      *BLANKS       SVVL01                                       BA6026
     C                   PARM      SVALK2        SVOP02                                       BA6026
     C                   PARM      *BLANKS       SVVL02                                       BA6026
     C                   PARM      SVALK3        SVOP03                                       BA6026
     C                   PARM      *BLANKS       SVVL03                                       BA6026
     C*****              PARM      *BLANKS       SVOP04                               BA6026MD062339
     C                   PARM      SVALK4        SVOP04                                     MD062339
     C                   PARM      *BLANKS       SVVL04                                       BA6026
     C*****              PARM      *BLANKS       SVOP05                               BA6026MD062339
     C                   PARM      SVALK5        SVOP05                                     MD062339
     C                   PARM      *BLANKS       SVVL05                                       BA6026
     C*****              PARM      *BLANKS       SVOP06                               BA6026MD062339
     C                   PARM      SVALK6        SVOP06                                     MD062339
     C                   PARM      *BLANKS       SVVL06                                       BA6026
     C*****              PARM      *BLANKS       SVOP07                               BA6026MD062339
     C                   PARM      SVALK7        SVOP07                                     MD062339
     C                   PARM      *BLANKS       SVVL07                                       BA6026
     C*****              PARM      *BLANKS       SVOP08                               BA6026MD062339
     C                   PARM      SVALK8        SVOP08                                     MD062339
     C                   PARM      *BLANKS       SVVL08                                       BA6026
     C                   PARM      *BLANKS       SVOP09                                       BA6026
     C                   PARM      *BLANKS       SVVL09                                       BA6026
     C                   PARM      *BLANKS       SVOP10                                       BA6026
     C                   PARM      *BLANKS       SVVL10                                       BA6026
                                                                                              BA6026
     C                   IF        PRtCdIn <> *Blanks  AND                                    BA6026
     C                             PRtCdIn <> '*NRF   '                                       BA6026
     C     *LOCK         IN        LDA                                                        BA6026
     C                   EVAL      DBFILE = 'SDSVALPD'                                        BA6026
     C                   EVAL      DBKEY = 'SVOP01'                                           BA6026
     C                   EVAL      DBASE = 903                                                BA6026
     C                   OUT       LDA                                                        BA6026
     C                   EXSR      *PSSR                                                      BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
      ** Load system values into arrays                                                       BA6026
     C                   EXSR      SrLoadTType                                                BA6026
      *                                                                                       BA6026
     C                   Call      'AONWRKR1'                                                 BA6026
     C                   Parm      *BLANKS       PRtCdIn                                      BA6026
     C                   Parm      '*KEY'        POptnIn                                      BA6026
     C                   Parm      'SWIFT'       PNwrkIn                                      BA6026
     C     DSNwrk        Parm                    DSLDY                                        BA6026
      *                                                                                       BA6026
     C                   If        PRtCdIn <> *Blanks                                         BA6026
     C     *Lock         In        LDA                                                        BA6026
     C                   Eval      DBASE = 946                                                BA6026
     C                   Eval      DBFILE = 'SDNWRKPD'                                        BA6026
     C                   Eval      DBKEY  = 'SWIFT'                                           BA6026
     C                   Eval      DBPGM = 'MG001901'                                         BA6026
     C                   Out       LDA                                                        BA6026
     C                   Exsr      *PSSR                                                      BA6026
     C                   Else                                                                 BA6026
     C                   Z-Add     EDNOLN        @Ln               2 0                        BA6026
     C                   Z-Add     EDNCLN        @Lc               3 0                        BA6026
     C                   Endif                                                                BA6026
                                                                                              BA6026
     C                   ELSE                                                                 BA6026
     C                   EVAL      BA6026 = 'N'                                               BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
     C     K1M940        KList                                                                BA6026
     C                   KFld                    K1Swid            4                          BA6026
     C                   KFld                    K1Trat            5                          BA6026
      *                                                                                     MD062385
      ** Check if CSW101 is switched *ON.                                                   MD062385
      *                                                                                     MD062385
     C                   Move      'N'           CSW101                                     MD062385
     C                   Call      'AOSARDR0'                                               MD062385
     C                   Parm      *BLANK        ##RTCD                                     MD062385
     C                   Parm      '*FIRST  '    ##OPTN                                     MD062385
     C                   Parm      'CSW101'      ##SARD                                     MD062385
     C     SCSARD        Parm      *BLANKS       DSFDY                                      MD062385
      *                                                                                     MD062385
     C     ##RTCD        Ifeq      *BLANK                                                   MD062385
     C                   Move      'Y'           CSW101            1                        MD062385
     C                   Endif                                                              MD062385
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA
      ** as an external data area
      *
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CPY@
(c) Finastra International Limited 2009
** ArrExtName
DDEX1
DDEX2
DDEX3
DDEX4
DDEX5
DDEX6
DDEX7
DDEX8
DDEX9
DDEX10
DDEX11
DDEX12
DDEX13
DDEX14
DDEX15
DDEX16
DDEX17
DDEX18
DDEX19
DDEX20
DDEX21
DDEX22
** ArrLen22
03
27
10
27
27
27
27
27
27
35
35
35
35
10
24
27
27
03
34
35
35
35
