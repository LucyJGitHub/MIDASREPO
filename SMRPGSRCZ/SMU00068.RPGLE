     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update incorrect A/c subtypes (Live A/Cs)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00068 - Update Account sub-type to match Account Code.    *
      *             Only change for live Accounts where only the      *
      *             sub-type differs, but the type is the same.       *
      *             Applies to Release 10 systems (due to file in     *
      *             use).                                             *
      *             As ACCNTAB is updated, it is best run with        *
      *             other users off the system.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 104037  *CREATE    Date 09May97               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *   CRE073 - Interest Rate Rounding (Recompile)                 *
      *   CRE075 - Effective Date for Retail Accounts (Recompile)     *
      *   BG26993 - Delivery of upgrade programs to core.             *
      *           - Renamed program S10403701.                        *
      *   Created for 104037  -  Some Retail Account sub-type fields  *
      *                          were blank or wrong. (ref 103398)    *
      *                                                               *
      *****************************************************************
      *                                                               *
     FAUACNTV1  UF   E           K DISK
     FSDACODL0  IF   E           K DISK
      *
     C                   READ      ACCNTABF                               50
      *
     C     *IN50         DOWEQ     '0'
      *
      ** If this is a new Account Code, get details.
     C     ACOD          IFNE      SACOD
     C                   SETOFF                                       51
     C                   Z-ADD     ACOD          SACOD            10 0
     C                   MOVE      *ZEROS        AACOD            10
     C                   MOVE      ACOD          AACOD
     C     AACOD         CHAIN     SDACODL0                           51
     C                   ENDIF
      *
      ** If Account Code was found, and Account is live.
     C     *IN51         IFEQ      '0'
     C     RECI          ANDEQ     'D'
      *
      ** If the Account type is the same as the Account Code type,
      ** but the sub-type is different, update the ACCNTAB value.
      ** If the type is different, ignore, as problem needs more
      ** than a utility.
     C     A5ACTY        IFEQ      ATYP
     C     A5ACST        ANDNE     STYP
     C                   MOVE      A5ACST        STYP
     C                   UPDATE    ACCNTABF
     C                   ENDIF
     C                   ENDIF
      *
      ** Get next record.
     C                   READ      ACCNTABF                               50
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
