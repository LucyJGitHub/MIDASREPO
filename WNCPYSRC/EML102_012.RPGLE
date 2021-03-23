      *****************************************************************                       EML102
      *                                                               *                       EML102
      *  Midas - /COPY Member GL001425                                *                       EML102
      *                                                               *                       EML102
      *  EML102_012 - Midas GL Retrieve Postings by Network Account   *                       EML102
      *                                                               *                       EML102
      *  Last Amend No. EML102  *CREATE    Date 22Nov19               *                       EML102
      *                                                               *                       EML102
      *---------------------------------------------------------------*                       EML102
      *                                                               *                       EML102
      *  EML102 - Upgrade of UNL007 to FB2.1 SP21                     *                       EML102
      *       UNL007 - Extended Narratives                            *                       EML102
      *                                                               *                       EML102
      *****************************************************************                       EML102
      *                                                                                       EML102
      ** Key List to access the Batch Item Extended Information.                              EML102
      *                                                                                       EML102
     C                   IF        EML102 = 'Y'                                               EML102
      *                                                                                       EML102
     C     KeyAddInf2    KLIST                                                                EML102
     C                   KFLD                    WBatchNb                                     EML102
     C                   KFLD                    WItemNb                                      EML102
     C                   KFLD                    PSTD                                         EML102
      *                                                                                       EML102
     C     KeyAddInf2    CHAIN     GLJENPD2                           99                      EML102
     C                   IF        NOT *IN99                                                  EML102
     C                   CLEAR                   Ar_AddInf                                    EML102
     C                   Z-ADD     1             E                 2 0          Ext. Index    EML102
     C                   Z-ADD     1             A                 2 0          Add. Index    EML102
     C                   DOW       E < 17 AND A < 7                                           EML102
     C                   IF        Ar_ExtInf(E) <> *Blanks                                    EML102
     C                   EVAL      Ar_AddInf(A) = Ar_ExtInf(E)                                EML102
     C                   ADD       1             A                                            EML102
     C                   ENDIF                                                                EML102
     C                   ADD       1             E                                            EML102
     C                   ENDDO                                                                EML102
     C                   EVAL      MGADI1 = Ar_AddInf(1)                        Add. Inf. 1   EML102
     C                   EVAL      MGADI2 = Ar_AddInf(2)                        Add. Inf. 2   EML102
     C                   EVAL      MGADI3 = Ar_AddInf(3)                        Add. Inf. 3   EML102
     C                   EVAL      MGADI4 = Ar_AddInf(4)                        Add. Inf. 4   EML102
     C                   EVAL      MGADI5 = Ar_AddInf(5)                        Add. Inf. 5   EML102
     C                   EVAL      MGADI6 = Ar_AddInf(6)                        Add. Inf. 6   EML102
     C                   EVAL      MGAERI = *Blanks                             ERI Indicator EML102
     C                   ENDIF                                                                EML102
     C                   ENDIF                                                                EML102
      *                                                                                       EML102
      *****************************************************************                       EML102
      * End of /COPY EML102_012                                       *                       EML102
      *****************************************************************                       EML102
