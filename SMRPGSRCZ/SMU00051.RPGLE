     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update fields on TABTB36/SDSTRDPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00051 - Upgrade fields on TABTB36 and SDSTRDPD            *
      *                                                               *
      *  Function:  Set field AUTT on TABTB36 and BVAUTH on SDSTRDPD  *
      *             to '00'.                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. CPK026  *CREATE    Date 29Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPK026R01.                         *
      *  CPK026  - Update fields om TABTB36 and SDSTRDPD.             *
      *                                                               *
      *****************************************************************
      *
     FTABTB36   UF   E             DISK    INFSR(*PSSR)
     FSDSTRDPD  UF   E             DISK    INFSR(*PSSR)
      *
      /EJECT
      *
      * Update TABTB36.
     C     1             SETLL     TABTB36
     C                   READ      TABTB36
     C                   DOW       NOT %EOF
     C                   EVAL      AUTT = '00'
     C                   UPDATE    TABTB36F
     C                   READ      TABTB36
     C                   ENDDO
      *
      * Update SDSTRPD.
     C     1             SETLL     SDSTRDPD
     C                   READ      SDSTRDPD
     C                   DOW       NOT %EOF
     C                   EVAL      BVAUTH = '00'
     C                   UPDATE    SDSTRDD0
     C                   READ      SDSTRDPD
     C                   ENDDO
      *
      ** End program and return.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error Control subroutine                            *
      *                                                               *
      *  Called By :                                                  *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      *
      * Check to see that *PSSR has not already been called.
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
      * If *PSSR already run, then just end the program here.
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
