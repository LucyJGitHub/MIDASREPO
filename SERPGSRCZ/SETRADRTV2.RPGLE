     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade retrieve for TRADSDX2 records')         *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADRTV2 - SECURITIES TRADE RETRIEVE TRADSDX2              *
      *                                                               *
      *  Function:  This module retrieves a trade X2 record from      *
      *             the database.                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE045  *CREATE    Date 13Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FTRADSDY2  IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** Trade Extension in File Format (A)
     D TX2FilFmt     E DS                  EXTNAME(TRADSDX2)
      ** Trade Extension in File Format (A)
     D TX2AFilFmt    E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(A_)
      ** Trade Extension in File Format (B)
     D TX2BFilFmt    E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(B_)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   CLEAR                   TX2AFilFmt
     C                   CLEAR                   TX2BFilFmt
     C                   CLEAR                   RetCodeIn
      *
      *  *-----------------------------------------------*
      *  * Get Trade Extension Details (if present)      *
      *  *-----------------------------------------------*
      *
     C     CSW003        IFEQ      'Y'
     C                   MOVEL     'A'           T2WHEN
     C                   ELSE
     C                   MOVEL     ' '           T2WHEN
     C                   END
     C     TRADSY2K      CHAIN     TRADSDY2                           99
     C  N99              MOVEL     TX2FilFmt     TX2AFilFmt
     C                   MOVEL     'B'           T2WHEN
     C     TRADSY2K      CHAIN     TRADSDY2                           99
     C  N99              MOVEL     TX2FilFmt     TX2BFilFmt
 
      *
      * Return
      *
     C                   RETURN
 
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * (Midas) Trade Reference
     C                   PARM                    DDTDRF            6
      *
      * MT5XX - Phase 2 Message Generation is on.
     C                   PARM                    CSW003            1
      *
      * OUTPUTS
      *
      * (Current) trade extension in file format
     C                   PARM                    TX2AFilFmt
     C                   PARM                    TX2BFilFmt
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADRTV2'  DBPGM
      *
     C     TRADSY2K      KLIST
     C                   KFLD                    DDTDRF
     C                   KFLD                    T2WHEN
      *
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
