     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*S*D ***RPGBASEBNC****************************************************                    AR1097467
/*STD *  RPGSQLBND                                                    *                    AR1097467
/*EXI *  TEXT('Midas GO Bulk Update of GZFCLTLVPD: initialization')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOFCLVIN - Bulk Update of Global File GZFCLTLVPD             *
      *             Initialization: delete records for the zone       *
      *                                                               *
      *             In original (non-task split) mode the work of     *
      *             this program is done in *inzsr of gofcltlvpd.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. MD022096           Date 28Aug13               *
      *  Prev Amend No. MD020751           Date 21Jun13               *
      *                 MD020264           Date 23May13               *
      *                 AR1097467          Date 26Mar13               *
      *                 CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CGP015  *CREATE    Date 06Mar09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022096 - GOCFCLVIN performance improvement                 *
      *  MD020751 - Component GOCFCLVIN fails trying to delete record *
      *             from GZFCLTLVPD with return code 100              *
      *             (no record found)                                 *
      *  MD020264 - FCIP Mainlist Duplicate Facilities were shown     *
      *  AR1097467 - Expected 15% COB run optimisation not met        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT039: include new fields introduced by CER020 in   *
      *           GZFCLTYFM(V_#FCLTY), PEXD and PNXD. (Recompile)     *
      *  CGP015 - Task Split of Bulk update of Facilities listview    *
      *                                                               *
      *****************************************************************
 
     F***GZFCLTLVL1UF   E           K DISK    INFSR(*PSSR)                                 AR1097467
 
      *****************************************************************
 
      ** Program Status Data Structure
 
     D/COPY ZACPYSRC,PSDS
 
      *****************************************************************
 
     C     *ENTRY        PList
     C                   Parm                    I_ZONE           10
 
     C*****I_ZONE        SetLl     GZFCLTLVL1                                              AR1097467
     C*****I_ZONE        ReadE     GZFCLTLVL1                                              AR1097467
     C**********         DoW       NOT %EOF(GZFCLTLVL1)                                    AR1097467
     C**********         Delete    FCLTLVD0                                                AR1097467
     C*****I_ZONE        ReadE     GZFCLTLVL1                                              AR1097467
     C**********         EndDo                                                             AR1097467
                                                                                           AR1097467
     C/EXEC SQL                                                                            AR1097467
     C*+**delete*from*GZFCLTLVPD***************************************           AR1097467 MD022096
     C*+**where*CGZONE*=*:I_ZONE***************************************           AR1097467 MD020264
     C*+**where*CUSTZONE*=*:I_ZONE*************************************           MD020264  MD022096
     C+  Delete from                                                                        MD022096
     C+  GZFCLTLVPD A                                                                       MD022096
     C+  where                                                                              MD022096
     C+  A.CUSTZONE = :I_ZONE and                                                           MD022096
     C+  not exists                                                                         MD022096
     C+  (                                                                                  MD022096
     C+  select * from                                                                      MD022096
     C+  FCLTYFM B                                                                          MD022096
     C+  where                                                                              MD022096
     C+  A.PADCNUM = B.CNUM and                                                             MD022096
     C+  A.PADFACT = B.FACT and                                                             MD022096
     C+  A.PADFCNO = B.FCNO                                                                 MD022096
     C+  )                                                                                  MD022096
     C+  with nc                                                                            MD022096
     C/END-EXEC                                                                            AR1097467
                                                                                           AR1097467
     C**********         IF        SQLCOD <> 0                                    AR1097467 MD020751
     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100                            MD020751
     C                   EXSR      *PSSR                                                   AR1097467
     C                   ENDIF                                                             AR1097467
 
     C                   Eval      *InLr = *On
     C                   Return
 
      *****************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *****************************************************************
     C     *PSSR         BegSr
 
     C                   Dump
     C                   SetOn                                        LRU7U8
     C                   Return
 
     C                   EndSr
