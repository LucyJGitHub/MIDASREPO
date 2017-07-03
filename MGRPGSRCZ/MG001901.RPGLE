     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
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
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. MD044271           Date 21Mar17               *
      *  Prev Amend No. MD000091           Date 14May13               *
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
     D Arr22           S             70A   DIM(22)
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
     C                   EXSR      SrNarr
      *
     C                   EXSR      SRFormat
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
      ** If network/format is 'SWIFT' then the max chars allowed is 390
      *
     C                   IF        EDNWRK = 'SWIFT' OR EDF86F ='SWIFT'
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
     C                   DO        22
     C                   EVAL      Arr22(WIdx) = ParrExt22(WIdx)
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
      ** Initialize arrays
      *
     C                   EVAL      Arr22 = *BLANKS
     C                   EVAL      PRtcd = *BLANKS
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
(c) Misys International Banking Systems Ltd. 2009
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
