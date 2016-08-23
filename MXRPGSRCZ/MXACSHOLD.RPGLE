     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Holiday for Country Calendar')         *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSHOLD - Access Holiday File for Country Calendar         *
      *                                                               *
      *  Function:  This module accesses Holiday File                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CTI006  *CREATE    Date 31Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *                                                               *
      *****************************************************************
 
     FSDHOLL1   IF   E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      * Additional Correspondent Details
     D SDHOL         E DS                  EXTNAME(SDHOLPD)
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        INCYCD            3
 
      ** If no currency is supplied, then pass back a blank format
 
     C     K_Holi        KLIST
     C                   KFLD                    k_CurCode
     C                   KFLD                    k_LocCode
 
     C                   IF        INCYCD = *BLANKS
     C                   CLEAR                   SDHOL
     C                   ELSE
 
      ** Access the holiday file
 
     C     INCYCD        IFNE      PrvCYCD
     C                   MOVEL     INCYCD        PrvCYCD           3
     C                   Z-ADD     *ZERO         Num_ExtRcs        5 0
     C                   MOVEL     INCYCD        k_CurCode         3
     C                   MOVEL     '***'         k_LocCode         3
     C     K_Holi        SETLL     @HOLPHK
     C                   ENDIF
 
     C     K_Holi        READE     @HOLPHK                                99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   MOVEL     *BLANKS       PrvCYCD           3
     C                   Z-ADD     *ZERO         Num_ExtRcs
     C                   ELSE
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    DGLCD
     C                   ENDIF
     C                   ENDIF
 
      ** Set up output data
 
     C                   EVAL      InData = SDHOL
 
      ** Return
 
     C                   RETURN
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANKS       PrvCYCD
 
     C                   ENDSR
      *
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
