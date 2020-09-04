     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas TI SDCTRYPD Trigger - HBPF Country codes')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI000102 - Midas TI Trigger program                          *
      *                                                               *
      *  Function:  This program updates/adds/deletes a record in     *
      *             HBPF for Country codes                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Called By: SCTRIGGER                                         *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 05Jun06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG3697  *CREATE    Date 23May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                     *
      *  BG3697 - Convert TI SQL triggers to RPG                      *
      *                                                               *
      *****************************************************************
 
      *** TI Country codes (HBCFN = C7)
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
 
      * DS to define country fields
     DCtryFormat     E DS                  ExtName(SDCTRYPD)
 
      * 'Before' variables for SQL key details and update checking
     DBCtryID          S             10
     DBCtryDetails     S             30
 
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
     C                   Eval      CtryFormat = I#BIMG
     C                   Eval      BCtryID = A4CNCD
     C                   Eval      BCtryDetails = A4CNNM
 
      * Get after image
     C                   Eval      CtryFormat = I#AIMG
 
      * Set SQL return code
     C                   Eval      SQLCOD = 0
 
      * Trigger event types:
      * '1'=Insert, '2'=Delete, '3'=Update
      *
      * Insert
     C                   If        TrgEvent = '1'
     C/EXEC SQL
     C+ INSERT INTO HBPF
     C+ (HBLNM, HBCFN, HBCFL, HBRNM)
     C+ VALUES('GB', 'C7', :A4CNCD, :A4CNNM)
     C/END-EXEC
     C                   EndIf
      *
      * Delete
     C                   If        TrgEvent = '2'
     C/EXEC SQL
     C+ DELETE FROM HBPF
     C+ WHERE HBLNM='GB' AND HBCFN='C7' AND HBCFL = :BCtryID
     C/END-EXEC
     C                   EndIf
      *
      * Update
     C                   If        TrgEvent = '3'
      *
      * Check if any of the fields to go on HBPF have changed -
      * only update if true
     C                   If        BCtryID <> A4CNCD Or
     C                             BCtryDetails <> A4CNNM
     C/EXEC SQL
     C+ UPDATE HBPF
     C+ SET HBCFL = :A4CNCD, HBRNM = :A4CNNM
     C+ WHERE HBLNM='GB' AND HBCFN='C7' AND HBCFL = :BCtryID
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
