     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch list configuration convert')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDWLCCCVT - Watch List Configuration Convert                 *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D MTYPARR         S              3A   DIM(20)
     D INEXARR         S              1A   DIM(20)
     D COMBARR         S              1A   DIM(80)
 
     D WLCCFilFmt    E DS                  EXTNAME(SDWLCCPD)
      ** Watch List Configuration in File Format
 
     D WLCMDets      E DS                  EXTNAME(SDWLCMPD)
     D WLCM                   53    132
      ** Watch List Configuration Definition File
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TempVar         S              4A
     D A               S              2P 0
     D B               S              2P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialisation
 
     C                   EXSR      SRINIT
 
      ** Set screen fields
 
     C                   EXSR      SRSCREEN
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSCREEN - Set Screen Fields                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSCREEN      BEGSR
 
     C                   EVAL      #1FUNC = W1FUNC
     C                   EVAL      #1FUND = W1FUND
     C                   EVAL      #1EWLC = W1EWLC
     C                   EVAL      #1PFRQ = W1PFRQ
     C                   IF        W1PDYN <> *ZEROS
     C                   MOVE      W1PDYN        #1PDYN
     C                   ELSE
     C                   MOVE      *BLANKS       #1PDYN
     C                   ENDIF
 
     C                   EVAL      A = 1
     C                   EVAL      B = 1
 
     C                   DOW       A <= 20
     C                   EVAL      TempVar = MTYPARR(A) + INEXARR(A)
     C                   MOVEA     TempVar       COMBARR(B)
     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 4
     C                   ENDDO
 
     C                   MOVEA     COMBARR       WLCM
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Blank outputs
 
     C                   MOVEL     *BLANKS       WLCMDets
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Watch List Configuration in File Format
     C                   PARM                    WLCCFilFmt
      ** Message Type
     C                   PARM                    MTYPARR
      ** Include/Exclude Indicator
     C                   PARM                    INEXARR
 
      ** Output Parameters
      ** Watch List Configuration Definition File
     C                   PARM                    WLCMDets
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDWLCCCVT'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
