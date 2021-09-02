     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT BIC Plus QUICK Index Clearing Codes')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0706 - Midas FT BIC Plus QUICK Index Clearing Codes       *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 ESL044             Date 20Jan2005             *
      *                 ESL038             Date 01Dec2004             *
      *                 EEE065   *CREATE   Date 21Oct2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *  ESL044 - Local Clearing                                      *
      *  ESL038 - ING FT STP Development                              *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FFTBSCHV2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : BIC Plus Index
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array containing Copyright statement
     D/COPY MECPYSRC,SRERRD_ILE
      *
      *  Copysource for error processing
      *
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTMA                 7     12
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
     D BSchV0        E DS                  EXTNAME(FTBschV0)
      *
      * Get Rundate - Rundate  *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
     D P2PARM          DS           256
      * O : Beneficiary
     D  P2BENB                 1     11
      * O : Beneficiary country
     D  P2BENC                12     13
     D  P2CLCD                14     48
     D  P2IBAN                49     49                                                       ESL044
      *
     D P3PARM          DS           256
      * O : Beneficiary
     D  P3BENB                 1     11
      * O : Beneficiary country
     D  P3BENC                12     13

      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P2Parm
     C                   PARM                    P3Parm
      *
      *  Set up primary reference
      *
     C                   Clear                   P0Rtn
     C                   Movel     'Search '     W0PREF
      *
     C                   If        First = *blanks
     C                   Exsr      SrInit
     C                   Movel     'Y'           First             1
     C                   Endif

      * If not IBAN BIC Search                                                                ESL044
     C                   If        P2Iban <> 'Y'                                              ESL044
     C                   Exsr      SrBicPlus
     C                   Else                                                                 ESL044
      * IBAN Deconstruction                                                                   ESL044
     C                   Exsr      SrIban                                                     ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
      * Exit
     C                   Return
      *
     C/EJECT                                                                                  ESL044
      *****************************************************************                       ESL044
      *                                                               *                       ESL044
      *  SrBicPlus: Format via Bic Plus                               *                       ESL044
      *                                                               *                       ESL044
      *  CALLED BY: Main processing                                   *                       ESL044
      *                                                               *                       ESL044
      *****************************************************************                       ESL044
     CSR   SrIban        BEGSR                                                                ESL044
      *                                                                                       ESL044
      *  Set up subroutine stack name                                                         ESL044
      *                                                                                       ESL044
     C                   ADD       1             Q                 5 0                        ESL044
     C                   MOVEL     'SrIban   '   @STK(Q)                                      ESL044
                                                                                              ESL044
      *  This is by country as each is different                                              ESL044
      *  Idea is to get the national id  and return either a BIC or BIC Plus Key              ESL044
      *                                                                                       ESL044
     C                   Eval      BsCntc = %Subst(P2ClCD:2:2)                                ESL044
     C                   Select                                                               ESL044
      * Andorra                                                                               ESL044
     C                   When      BsCntc = 'AD'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:8)                                ESL044
      * Austria                                                                               ESL044
     C                   When      BsCntc = 'AT'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:5)                                ESL044
      * Belgium                                                                               ESL044
     C                   When      BsCntc = 'BE'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:3)                                ESL044
      * Belgium                                                                               ESL044
     C                   When      BsCntc = 'DE'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:8)                                ESL044
      * Croatia                                                                               ESL044
     C                   When      BsCntc = 'HR'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:7)                                ESL044
      * Cyprus                                                                                ESL044
     C                   When      BsCntc = 'CY'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:8)                                ESL044
      * Czech Republic                                                                        ESL044
     C                   When      BsCntc = 'CZ'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:4)                                ESL044
      * Denmark                                                                               ESL044
     C                   When      BsCntc = 'DK'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:4)                                ESL044
      * Estonia                                                                               ESL044
     C                   When      BsCntc = 'EE'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:4)                                ESL044
      * Finland                                                                               ESL044
     C                   When      BsCntc = 'FI'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:6)                                ESL044
      * France                                                                                ESL044
     C                   When      BsCntc = 'FR'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:10)                               ESL044
      * Germany                                                                               ESL044
     C                   When      BsCntc = 'DE'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:8)                                ESL044
      * Gibraltar                                                                             ESL044
     C                   When      BsCntc = 'GI'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:4)                                ESL044
      * Greece                                                                                ESL044
     C                   When      BsCntc = 'GR'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:7)                                ESL044
      * Hungary                                                                               ESL044
     C                   When      BsCntc = 'HU'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:8)                                ESL044
      * Iceland                                                                               ESL044
     C                   When      BsCntc = 'IS'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:4)                                ESL044
      * Ireland                                                                               ESL044
     C                   When      BsCntc = 'IE'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:10:6)                               ESL044
      * Italy                                                                                 ESL044
     C                   When      BsCntc = 'IT'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:7:10)                               ESL044
      * Latvia                                                                                ESL044
     C                   When      BsCntc = 'LV'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:4)                                ESL044
      * Liehtenstein                                                                          ESL044
     C                   When      BsCntc = 'LI'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:5)                                ESL044
      * Lithuania                                                                             ESL044
     C                   When      BsCntc = 'LT'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:5)                                ESL044
      * Luxembourg                                                                            ESL044
     C                   When      BsCntc = 'LU'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:3)                                ESL044
      * Macedonia                                                                             ESL044
     C                   When      BsCntc = 'MK'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:3)                                ESL044
      * Malte                                                                                 ESL044
     C                   When      BsCntc = 'MT'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:5)                                ESL044
      * Netherlands                                                                           ESL044
     C                   When      BsCntc = 'NL'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:4)                                ESL044
      * Norway                                                                                ESL044
     C                   When      BsCntc = 'NO'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:4)                                ESL044
      * Poland                                                                                ESL044
     C                   When      BsCntc = 'PL'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:8)                                ESL044
      * Portugal                                                                              ESL044
     C                   When      BsCntc = 'PT'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:8)                                ESL044
      * Romania                                                                               ESL044
     C                   When      BsCntc = 'RO'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:4)                                ESL044
      * Slovak Republic                                                                       ESL044
     C                   When      BsCntc = 'SK'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:4)                                ESL044
      * Slovenia                                                                              ESL044
     C                   When      BsCntc = 'SI'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:5)                                ESL044
      * Spain                                                                                 ESL044
     C                   When      BsCntc = 'ES'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:9)                                ESL044
      * Sweden                                                                                ESL044
     C                   When      BsCntc = 'SE'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:3)                                ESL044
      * Switzerland                                                                           ESL044
     C                   When      BsCntc = 'CH'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:6:5)                                ESL044
      * United Kingdom                                                                        ESL044
     C                   When      BsCntc = 'GB'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:10:6)                               ESL044
      * Other                                                                                 ESL044
     C                   Other                                                                ESL044
     C                   Goto      ExIban                                                     ESL044
     C                   Endsl                                                                ESL044
                                                                                              ESL044
     C     KBschV2       Setll     @BschV2                                                    ESL044
     C     KBschV2       Reade     @BschV2                                90                  ESL044
      * If found continue and read whole file                                                 ESL044
     C                   If        *In90 = *Off                                               ESL044
     C                   Dou       *In90 = *On                                                ESL044
                                                                                              ESL044
     C                   If        BsBic <> *blanks                                           ESL044
     C                   Eval      P3Benb = BsBIC                                BIC Code     ESL044
     C                   Eval      P0Rtn = '*FBic'                                            ESL044
     C                   Leave                                                                ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
     C                   If        BsBic = *blanks                                            ESL044
     C                   Eval      P3Benb = BsKey                                BIC Code     ESL044
     C                   Eval      P0Rtn = '*FBkey'                                           ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
     C     KBschV2       Reade     @BschV2                                90                  ESL044
     C                   Enddo                                                                ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
      *                                                                                       ESL044
      *  Unwind subroutine stack name                                                         ESL044
      *                                                                                       ESL044
     C     ExIban        TAG                                                                  ESL044
     C                   MOVEA     *BLANKS       @STK(Q)                                      ESL044
     C                   SUB       1             Q                                            ESL044
      *                                                                                       ESL044
     CSR                 ENDSR                                                                ESL044
      *****************************************************************                       ESL044
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrBicPlus: Format via Bic Plus                               *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrBicPlus     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrBicPlus'   @STK(Q)

      * Check if Bic Directory
     C     KBschV2       Klist
     C                   Kfld                    BSCntc
     C                   Kfld                    BSNati

     C                   Clear                   P3Parm
     C                   Eval      P0Rtn = '*Nrf'

     C                   Select
     C                   When      %Subst(P2ClCD:1:4) = '//BL'
     C                   Eval      BsCntc = 'DE'
     C                   Eval      BsNati = %Subst(P2ClCd:5:8)
     C                   When      %Subst(P2ClCD:1:3) = '/BL'
     C                   Eval      BsCntc = 'DE'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:4:8)                                ESL044
     C                   When      %Subst(P2ClCD:1:4) = '//SC'                                ESL044
     C                   Eval      BsCntc = 'GB'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:5:8)                                ESL044
     C                   When      %Subst(P2ClCD:1:3) = '/SC'                                 ESL044
     C                   Eval      BsCntc = 'GB'                                              ESL044
     C                   Eval      BsNati = %Subst(P2ClCd:4:8)                                ESL044
     C                   Other
     C                   Eval      P0Rtn = '*Nsee'
     C                   Goto      ExBicPlus
     C                   Endsl

     C     KBschV2       Setll     @BschV2
     C     KBschV2       Reade     @BschV2                                90
      * If found continue and read whole file
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On

     C                   If        BsBic <> *blanks
     C                   Eval      P3Benb = BsBIC                                BIC Code
     C                   Eval      P0Rtn = '*FBic'
     C                   Leave
     C                   Endif

     C                   If        BsBic = *blanks
     C                   Eval      P3Benb = BsKey                                BIC Code
     C                   Eval      P0Rtn = '*FBkey'
     C                   Endif

     C     KBschV2       Reade     @BschV2                                90
     C                   Enddo
     C                   Endif

      *
      *  Unwind subroutine stack name
      *
     C     ExBicPlus     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrInit        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *================================================================
      *
      * File and Program Error Processing
      *
     C/COPY MECPYSRC,SRERRC_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
