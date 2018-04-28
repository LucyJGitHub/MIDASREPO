     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Position Settlement extension 1')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSPSTX1 - Access Position Settlement Extension 1          *
      *                                                               *
      *  Function:  This module accesses Position Settlement X1 file  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSW025  *CREATE    Date 28May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW025 - Midas Message Manager                               *
      *                                                               *
      *****************************************************************
 
     FPOSETDY1  UF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Position Settlement Record Detail
     D POSETX1       E DS                  EXTNAME(POSETDX1)
 
      * Define key fields for position settlement files
     D #PBCA           S                   LIKE(POPBCA)
     D #PSSH           S                   LIKE(POPSSH)
     D #PCPY           S                   LIKE(POPCPY)
     D #PDUD           S                   LIKE(POPDUD)
     D #PEVT           S                   LIKE(POPEVT)
 
     D                 DS
     D DDate3A                 1      3A
     D DDate05P                1     03P 0
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        #PBCA
     C                   MOVEL     I#LFD2        #PSSH
     C                   MOVEL     I#LFD3        #PCPY
     C                   MOVEL     I#LFD4        DDate3A
     C                   Z-ADD     DDate05P      #PDUD
     C                   MOVEL     I#LFD5        #PEVT
     C
 
      * Access the position settlement detail
 
     C     PSTKEY        CHAIN     POSETDY1                           99
 
      * If the position settlement not found
      * pass back a blank format
 
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   POSETX1
     C                   ELSE
     C                   MOVE      PORCDG        TEMPFLD           1
     C                   MOVE      'Y'           PORCDG
     C                   UPDATE    POSETDD1
     C                   MOVE      TEMPFLD       PORCDG            1
     C                   ENDIF
 
 
      * Set up output data
 
     C                   EVAL      InData = POSETX1
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Key fields for the POSET1
 
     C     PSTKEY        KLIST
     C                   KFLD                    #PBCA             3
     C                   KFLD                    #PSSH            10
     C*****              KFLD                    #PCPY             6 0                        CSD027
     C                   KFLD                    #PCPY             6                          CSD027
     C                   KFLD                    #PDUD
     C                   KFLD                    #PEVT
 
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
