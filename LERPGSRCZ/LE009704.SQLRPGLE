     H DEBUG
     H ALWNULL(*USRCTL)                                                                      CER073D
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
/*S*D****RPGBASEMOD****************************************************                      CER073D
/*STD *  RPGSQLBND                                                    *                      CER073D
/*EXI *  TEXT('Midas LE CER073 CLIP Initialization pgm')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE009704 - Midas LE CER073 CLIP initialization               *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. CER073D            Date 13Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER073B            Date 25Sep17               *
      *                 CER073A            Date 05Sep17               *
      *                 CER073   *CREATE   Date 10Jul17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER073D - Upgrade of EML014 to FB2.1 SP23                    *
      *      EML014 - AnaCredit Reporting Enhancement                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CER073B - CER073 Change Control 2 (Recompile)                *
      *  CER073A - CER073 Change Control 1 (Recompile)                *
      *  CER073 - AnaCredit Reporting                                 *
      *                                                               *
      *****************************************************************

     FCLOANCL   IF   E             DISK    INFSR(*PSSR)

     F***LEANACQD  O    E             DISK                                                   CER073D
     FLEANACI0  IF   E           K DISK                                                      CER073D
     FFCLTYFM   IF   E             DISK    INFSR(*PSSR)                                      CER073D
     FFCANACI0  IF   E           K DISK                                                      CER073D

      ** =======
      ** D-specs
      ** =======

     D LEANAC        E DS                  EXTNAME(LEANACQD)

      *****************************************************************
      /EJECT
      *****************************************************************
     C     KFAnac        Klist                                                               CER073D
     C                   Kfld                    FCnum             6                         CER073D
     C                   Kfld                    Fact                                        CER073D
     C                   Kfld                    Fcno                                        CER073D

     C                   CLEAR                   LEANAC

     C     1             SETLL     CLOANCL
     C                   READ      CLOANCL

     C                   DOW       NOT %EOF(CLOANCL)
     C**********         EVAL      ACLNRF = LNRF                                             CER073D
     C**********         EVAL      ACBRCD = BRCA                                             CER073D

     C                   Move      *Blanks       LLnrf             6                         CER073D
     C                   Move      *Blanks       LCnum             6                         CER073D
     C                   Move      Lnrf          LLnrf                                       CER073D
     C                   Move      Cnum          LCnum                                       CER073D
     C     LLnrf         Chain     LEANACI0                           89                     CER073D
     C     *In89         Ifeq      *On                                                       CER073D
     C**********         WRITE     LEANACD0                                                  CER073D
      *                                                                                      CER073D
     C/exec SQL                                                                              CER073D
     C+ insert into LEANACQD                                                                 CER073D
     C+ (                                                                                    CER073D
     C+  AcLnrf                                                                              CER073D
     C+ ,AcBrcd                                                                              CER073D
     C+ ,AcInrc                                                                              CER073D
     C+ ,AcInrf                                                                              CER073D
     C+ ,AcScid                                                                              CER073D
     C+ ,AcFvch                                                                              CER073D
     C+ ,AcTrfa                                                                              CER073D
     C+ ,AcTyos                                                                              CER073D
     C+ ,AcAcoi                                                                              CER073D
     C+ ,AcBsre                                                                              CER073D
     C+ ,AcSoen                                                                              CER073D
     C+ ,AcAcwo                                                                              CER073D
     C+ ,AcAima                                                                              CER073D
     C+ ,AcToim                                                                              CER073D
     C+ ,AcIamd                                                                              CER073D
     C+ ,AcAcfv                                                                              CER073D
     C+ ,AcDtps                                                                              CER073D
     C+ ,AcPase                                                                              CER073D
     C+ ,AcSfar                                                                              CER073D
     C+ ,AcDtrs                                                                              CER073D
     C+ ,AcCara                                                                              CER073D
     C+ ,AcCrc1                                                                              CER073D
     C+ ,AcCrc2                                                                              CER073D
     C+ ,AcCrc3                                                                              CER073D
     C+ ,AcCrc4                                                                              CER073D
     C+ ,AcCrc5                                                                              CER073D
     C+ ,AcCrd1                                                                              CER073D
     C+ ,AcCrd2                                                                              CER073D
     C+ ,AcCrd3                                                                              CER073D
     C+ ,AcCrd4                                                                              CER073D
     C+ ,AcCrd5                                                                              CER073D
     C+ ,AcCprs                                                                              CER073D
     C+ ,AcCpro                                                                              CER073D
     C+ ,AcPurp                                                                              CER073D
     C+ ,AcSubd                                                                              CER073D
     C+ ,AcDfsi                                                                              CER073D
     C+ ,AcDdsi                                                                              CER073D
     C+ ,AcJla1                                                                              CER073D
     C+ ,AcJla2                                                                              CER073D
     C+ ,AcJla3                                                                              CER073D
     C+ ,AcJla4                                                                              CER073D
     C+ ,AcJla5                                                                              CER073D
     C+ ,AcEir                                                                               CER073D
     C+ )                                                                                    CER073D
     C+ Values                                                                               CER073D
     C+ (                                                                                    CER073D
     C+  :LLnrf                                                                              CER073D
     C+ ,:Brca                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , '15'                                                                               CER073D
     C+ , '1'                                                                                CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ ,:LCnum                                                                              CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ )                                                                                    CER073D
     C/End-Exec                                                                              CER073D
      *                                                                                      CER073D
     C                   Endif                                                               CER073D
     C                   READ      CLOANCL                                                   CER073D
     C                   ENDDO                                                               CER073D
                                                                                             CER073D
     C     1             Setll     FCLTYFM                                                   CER073D
     C                   READ      FCLTYFM                                                   CER073D
                                                                                             CER073D
     C                   DOW       NOT %EOF(FCLTYFM)                                         CER073D
     C                   Move      *Blanks       FCnum                                       CER073D
     C                   Move      Cnum          FCnum                                       CER073D
     C     KFanac        Chain     FcANACI0                           89                     CER073D
     C     *In89         Ifeq      *On                                                       CER073D
      *                                                                                      CER073D
     C/exec SQL                                                                              CER073D
     C+ insert into FCANACQD                                                                 CER073D
     C+ (                                                                                    CER073D
     C+  AcCnum                                                                              CER073D
     C+ ,AcFact                                                                              CER073D
     C+ ,AcFcno                                                                              CER073D
     C+ ,AcBrcd                                                                              CER073D
     C+ ,AcInrc                                                                              CER073D
     C+ ,AcInrf                                                                              CER073D
     C+ ,AcScid                                                                              CER073D
     C+ ,AcFvch                                                                              CER073D
     C+ ,AcTyos                                                                              CER073D
     C+ ,AcSoen                                                                              CER073D
     C+ ,AcToim                                                                              CER073D
     C+ ,AcIamd                                                                              CER073D
     C+ ,AcAcfv                                                                              CER073D
     C+ ,AcDtps                                                                              CER073D
     C+ ,AcPase                                                                              CER073D
     C+ ,AcSfar                                                                              CER073D
     C+ ,AcDtrs                                                                              CER073D
     C+ ,AcCrc1                                                                              CER073D
     C+ ,AcCrc2                                                                              CER073D
     C+ ,AcCrc3                                                                              CER073D
     C+ ,AcCrc4                                                                              CER073D
     C+ ,AcCrc5                                                                              CER073D
     C+ ,AcCprs                                                                              CER073D
     C+ ,AcCpro                                                                              CER073D
     C+ ,AcPurp                                                                              CER073D
     C+ ,AcSubd                                                                              CER073D
     C+ ,AcDfsi                                                                              CER073D
     C+ ,AcDdsi                                                                              CER073D
     C+ ,AcLfno                                                                              CER073D
     C+ )                                                                                    CER073D
     C+ Values                                                                               CER073D
     C+ (                                                                                    CER073D
     C+  :FCnum                                                                              CER073D
     C+ ,:Fact                                                                               CER073D
     C+ ,:Fcno                                                                               CER073D
     C+ ,:Brca                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
      ** End of EML014CC2                                                                    CER073D
     C+ )                                                                                    CER073D
     C/End-Exec                                                                              CER073D
      *                                                                                      CER073D
     C                   Endif                                                               CER073D
                                                                                             CER073D
     C                   Read      FCLTYFM                                                   CER073D
     C                   Enddo                                                               CER073D


     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
