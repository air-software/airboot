package com.airboot.common.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

/**
 * 租户基类
 *
 * @author airoland
 */
@Data
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
public class TenantEntity extends BaseEntity {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 租户ID
     */
    private Long tenantId;
    
}
