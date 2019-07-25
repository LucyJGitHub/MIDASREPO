     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Upload to BF - Entitlement Types')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000059 - Upload to BF - Entitlement Types                  *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. AR924843           Date 08Mar12               *
      *  Prev Amend No. AR883210           Date 21Dec11               *
      *                 CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR924843 - Entitlement Type 'Branch' as Booking Branch       *
      *  AR883210 - Additional Deliverables for BF                    *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *
     D*Enttyp***       S             50    INZ('BookingBranch')                             AR924843
     D EntDesc         S            250    INZ('Booking Branch')
     D Enttyp2         S             50    INZ('Branch')
     D*EntDesc2*       S            250    INZ('Branch')                                    AR924843
     D GrpID           S             30
     D Count           S              5  0 INZ(0)
     D UsrName         S             10
     D VerNum          S              9  0 INZ(1)
      *
      *
     C
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :Count FROM BFTB_ENTITLEMENTTYPES
     C*+*WHERE*BFENTITLEMENTTYPEPK*=*:Enttyp***************************                     AR924843
     C+ WHERE BFENTITLEMENTTYPEPK = :Enttyp2                                                AR924843
     C/END-EXEC
      *
     C                   IF        Count = 0
     C/EXEC SQL
     C+ INSERT INTO BFTB_ENTITLEMENTTYPES(
     C+ BFENTITLEMENTTYPEPK, BFDESCRIPTION, VERSIONNUM)
     C+ VALUES(
     C*+*:Enttyp,*:EntDesc,*:VerNum************************************                     AR924843
     C+ :Enttyp2, :EntDesc, :VerNum                                                         AR924843
     C+ )
     C/END-EXEC
     C                   ENDIF
      *
     C**********                                                                            AR924843
     C*/EXEC*SQL*******************************************************                     AR924843
     C*+*SELECT*COUNT(*)*INTO*:Count*FROM*BFTB_ENTITLEMENTTYPES********                     AR924843
     C*+*WHERE*BFENTITLEMENTTYPEPK*=*:Enttyp2**************************                     AR924843
     C*/END-EXEC*******************************************************                     AR924843
      **********                                                                            AR924843
     C**********         IF        Count = 0                                                AR924843
     C*/EXEC*SQL*******************************************************                     AR924843
     C*+*INSERT*INTO*BFTB_ENTITLEMENTTYPES(****************************                     AR924843
     C*+*BFENTITLEMENTTYPEPK,*BFDESCRIPTION,*VERSIONNUM)***************                     AR924843
     C*+*VALUES(*******************************************************                     AR924843
     C*+*:Enttyp2,*:EntDesc2,*:VerNum**********************************                     AR924843
     C*+*)*************************************************************                     AR924843
     C*/END-EXEC*******************************************************                     AR924843
     C**********         ENDIF                                                              AR924843
      **********                                                                            AR924843
      /EJECT
      *****************************************************************
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
