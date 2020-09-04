     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas TI SDCURRPD Trigger - HBPF/FXRATE86 Currency')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI000103 - Midas TI Trigger program                          *
      *                                                               *
      *  Function:  This program updates/adds/deletes a record in     *
      *             FXRATE86 & HBPF for Currencies                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Called By: SCTRIGGER                                         *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BG7765             Date 29Jun05               *
      *  Prev Amend No. BG3697  *CREATE    Date 23May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG7765 - FXRate86 not being updated on amend                 *
      *  BG3697 - Convert TI SQL triggers to RPG                      *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
      * DS to define Currency fields
     DCcyFormat      E DS                  ExtName(SDCURRPD)
 
      * 'Before' variables for SQL key details and update checking
     DBCcyID           S             10
     DBCcyDetails      S             30
     DBBuyRate         S             13  8                                                    BG7765
     DBBuySign         S              1                                                       BG7765
     DBSellRate        S             13  8                                                    BG7765
     DBSellSign        S              1                                                       BG7765
 
      *****************************************************************
     C/EJECT
      *****************************************************************
 
      * Entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      * Recover before and after image
     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000
 
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000
      *
      * Get variables from before image
      * (There won't be any on Insert)                                                        BG7765
     C                   If        TrgEvent <> '1'                                            BG7765
     C                   Eval      CcyFormat = I#BIMG
     C                   Eval      BCcyID = A6CYCD
     C                   Eval      BCcyDetails = A6CYNM
     C                   Eval      BBuyRate    = A6BYSR                                       BG7765
     C                   Eval      BBuySign    = A6BYSS                                       BG7765
     C                   Eval      BSellRate   = A6SLSR                                       BG7765
     C                   Eval      BSellSign   = A6SLSS                                       BG7765
     C                   EndIf                                                                BG7765
 
      * Get after image
     C                   Eval      CcyFormat = I#AIMG
 
      * Set SQL return code
     C                   Eval      SQLCOD = 0
      *
      * Trigger event types:
      * '1'=Insert, '2'=Delete, '3'=Update
     C                   If        TrgEvent = '1'
      *
      * HBPF
     C/EXEC SQL
     C+ INSERT INTO HBPF
     C+ (HBLNM, HBCFN, HBCFL, HBRNM)
     C+ VALUES('GB', 'C8', :A6CYCD, :A6CYNM)
     C/END-EXEC
      *
      * FXRATE86
     C/EXEC SQL
     C+ INSERT INTO FXRate86
     C+ (CODE53,
     C+  CURREN49,
     C+  BUYEXC03,
     C+  BUYSPR07,
     C+  SELLEX99,
     C+  SELLSP03,
     C+  BUYEXBY,
     C+  SELLEXBY,
     C+  BUYPERSPD,
     C+  SELLPERSPD,
     C+  CUSER,
     C+  AUSER,
     C+  DUALACTION,
     C+  TYPEFLAG,
     C+  TSTAMP)
     C+ VALUES(
     C+ 'SYSTEM',
     C+ :A6CYCD,
     C+ 0,
     C+ Case When :A6BYSS = '+'
     C+   Then :A6BYSR
     C+ Else
     C+   :A6BYSR * -1
     C+ End,
     C+ 0,
     C+ Case When :A6SLSS = '+'
     C+   Then :A6SLSR
     C+ Else
     C+   :A6SLSR * -1
     C+ End,
     C+ 'F',
     C+ 'F',
     C+ 0,
     C+ 0,
     C+ 0,
     C+ 0,
     C+ ' ',
     C+ 22624,
     C+ 1)
     C/END-EXEC
     C                   ENDIF
      *
      * Delete
     C                   If        TrgEvent = '2'
      *
      * HBPF
     C/EXEC SQL
     C+ DELETE FROM HBPF
     C+ WHERE HBLNM='GB' AND HBCFN='C8' AND HBCFL = :BCcyID
     C/END-EXEC
      *
      * FXRATE86
     C/EXEC SQL
     C+ DELETE FROM FXRate86
     C+ WHERE CURREN49 = :BCCyID
     C/END-EXEC
     C                   EndIf
      *
      * Amend
     C                   If        TrgEvent = '3'
      *
      * Check if any of the fields to go on HBPF have changed -
      * only update if true
     C                   If        BCcyID <> A6CYCD Or
     C                             BCcyDetails <> A6CYNM
      *
      * HBPF
     C/EXEC SQL
     C+ UPDATE HBPF
     C+ SET HBCFL = :A6CYCD, HBRNM = :A6CYNM
     C+ WHERE HBLNM='GB' AND HBCFN='C8' AND HBCFL = :BCcyID
     C/END-EXEC
     C                   EndIf                                                                BG7765
      *
      * Check if any of the fields to go on FXRate86 have changed -                           BG7765
      * only update if true                                                                   BG7765
     C                   If        BCcyID    <> A6CYCD Or                                     BG7765
     C                             BBuyRate  <> A6BYSR Or                                     BG7765
     C                             BBuySign  <> A6BYSS Or                                     BG7765
     C                             BSellRate <> A6SLSR Or                                     BG7765
     C                             BSellSign <> A6SLSS                                        BG7765
      * FXRATE86
     C/EXEC SQL
     C+ Update FXRate86
     C+ Set CURREN49 = :A6CYCD,                                                               BG7765
     C*****+ Set BUYSPR07 =                                                                   BG7765
     C+ BUYSPR07 =                                                                            BG7765
     C+ DEC(:A6BYSS CONCAT CHAR(:A6BYSR),22,8),
     C+ SELLSP03 =
     C+ DEC(:A6SLSS CONCAT CHAR(:A6SLSR),22,8)
     C+ WHERE CURREN49 = :BCCyID
     C/END-EXEC
     C                   EndIf
     C                   EndIf
      *
      * Check for successful completion
     C                   If        SQLCOD <> 0
     C                   ExSR      *PSSR
     C                   EndIf
 
     C                   SetOn                                        LR
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
 
     C                   SetOn                                        LR
     C                   Return
 
     C                   EndSR
 
      **---------------------------------------------------------------
      *****************************************************************
