     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT BOI Italy File Take-on')                      *
      *****************************************************************
      *                                                               *
      *  Midas - BOI Returns                                          *
      *                                                               *
      *  UTLUC139 - Midas UT Bank of Italy returns File Take-on       *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. LUC139  *Create    Date 20Jan21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FACCNTAXP  IF   E           K DISK    INFSR(*PSSR)
     FREACT1L0  UF A E           K DISK    INFSR(*PSSR)

     FCLOANKXP  IF   E           K DISK    INFSR(*PSSR)
     FLECLT1L0  UF A E           K DISK    INFSR(*PSSR)

     FFCLTYFXP  IF   E           K DISK    INFSR(*PSSR)
     FLEFCT1L0  UF A E           K DISK    INFSR(*PSSR)

     FGTEESGXP  IF   E           K DISK    INFSR(*PSSR)
     FLEGTT1L0  UF A E           K DISK    INFSR(*PSSR)

     FSDACODXP  IF   E           K DISK    INFSR(*PSSR)
     FSDACT1L0  UF A E           K DISK    INFSR(*PSSR)


      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ ===================================  ¦
      ** +--------------------------------------+

      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,STD_D_SPEC

     IREACT1D0
     I              PQCNUM                      PQCNUMN
     I              PQACOD                      PQACODN
     ILECLT1D0
     I              PFLNRF                      PFLNRFN
     ILEFCT1D0
     I              PRCNUM                      PRCNUMN
     ILEGTT1D0
     I              XPCNUM                      XPCNUMN
     ISDACT1D0
     I              PMACCD                      PMACCDN
      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Accounts
      *
     C     KACCT         KLIST
     C                   KFLD                    PQCNUMN
     C                   KFLD                    PQCCY
     C                   KFLD                    PQACODN
     C                   KFLD                    PQACSQ
     C                   KFLD                    PQBRCA

     C                   Movel     PQCnum        PQCnumN
     C                   Move      '0000000000'  PQAcodN
     C                   Movel     PQAcod        PQAcodN

     C                   READ      ACCNTAXP
     C                   DOW       NOT %EOF(ACCNTAXP)
     C
     C*****KACCT         Chain     REACT1L0

     C*****              If        Not %Found(REACT1L0)
     C                   Movel     PQCnum        PQCnumN
     C                   Move      '0000000000'  PQAcodN
     C                   Movel     PQAcod        PQAcodN
     C                   Write     REACT1D0
     C*****              ENDIF

     C                   Read      ACCNTAXP

     C                   Enddo

      ** Account Codes
      *
     C                   READ      SDACODXP
     C                   DOW       NOT %EOF(SDACODXP)
     C
     C                   Move      '0000000000'  PMAccdN
     C                   MoveL     PMAccd        PMAccdN
     C
     C     PMAccdN       Chain     SDACT1L0

     C                   If        Not %Found(SDACT1L0)
     C*                  z-add     0             NumAccd          10 0
     C*                  Move      PMAccd        NumAccd
     C*                  Mult      1000000       NumAccd
     C*                  MoveL     NumAccd       PMAccdN
     C                   Move      '0000000000'  PMAccdN
     C                   MoveL     PMAccd        PMAccdN
     C                   Write     SDACT1D0
     C                   ENDIF

     C                   Read      SDACODXP

     C                   Enddo

      ** Loans
      *
     C                   READ      CLOANKXP
     C                   DOW       NOT %EOF(CLOANKXP)
     C
     C                   MoveL     PfLnrf        PFLnrfN
     C     PFLnrfN       Chain     LECLT1L0

     C                   If        Not %Found(LECLT1L0)
     C                   Movel     PfLnrf        PfLnrfN
     C                   Write     LECLT1D0
     C                   ENDIF

     C                   Read      CLOANKXP

     C                   Enddo

      ** Facilities
      *
     C                   READ      FCLTYFXP
     C                   DOW       NOT %EOF(FCLTYFXP)
     C
     C                   MoveL     PrCnum        PrCnumN
     C     PrCnumN       Chain     LEFCT1L0

     C                   If        Not %Found(LEFCT1L0)
     C                   Movel     PrCnum        PrCnumN
     C                   Write     LEFCT1D0
     C                   ENDIF

     C                   Read      FCLTYFXP

     C                   Enddo

      ** Guarantees
      *
     C     KGTEE         KLIST
     C                   KFLD                    XPCnumN
     C                   KFLD                    XPFcln
     C                   KFLD                    XPGusn
     C
     C                   READ      GTEESGXP
     C                   DOW       NOT %EOF(GTEESGXP)
     C
     C                   MoveL     XpCnum        XpCnumN
     C     KGTee         Chain     LEGTT1L0

     C                   If        Not %Found(LEGTT1L0)
     C                   Movel     XpCnum        XpCnumN
     C                   Write     LEGTT1D0
     C                   ENDIF

     C                   Read      GTEESGXP

     C                   Enddo

     C                   Eval      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN

     C                   ENDSR
